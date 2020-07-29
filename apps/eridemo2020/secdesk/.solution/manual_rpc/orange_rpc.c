#include "orange_rpc.h"
#include "zmq.h"
#define TAG_MATCH(X, Y) (X.mux == Y.mux && X.sec == Y.sec && X.typ == Y.typ)
#define WRAP(X) void *_wrapper_##X(void *tag) { while(1) { _handle_##X(tag); } }

void my_type_check(uint32_t typ, codec_map *cmap) {
  if ( (typ >= MY_DATA_TYP_MAX) || (cmap[typ].valid==0) ) {
    exit (1);
  }
}

void my_xdc_register(codec_func_ptr encode, codec_func_ptr decode, int typ, codec_map *cmap) {
  cmap[typ].valid=1;
  cmap[typ].encode=encode;
  cmap[typ].decode=decode;
}

/* Serialize tag onto wire (TODO, Use DFDL schema) */
void my_tag_encode (gaps_tag *tag_out, gaps_tag *tag_in) {
  tag_out->mux = htonl(tag_in->mux);
  tag_out->sec = htonl(tag_in->sec);
  tag_out->typ = htonl(tag_in->typ);
}

/* Convert tag to local host format (TODO, Use DFDL schema) */
void my_tag_decode (gaps_tag *tag_out, gaps_tag *tag_in) {
  tag_out->mux = ntohl(tag_in->mux);
  tag_out->sec = ntohl(tag_in->sec);
  tag_out->typ = ntohl(tag_in->typ);
}

/* Convert tag to local host format (TODO, Use DFDL schema) */
void my_len_encode (uint32_t *out, size_t len) {
  *out = ntohl((uint32_t) len);
}

/* Convert tag to local host format (TODO, Use DFDL schema) */
void my_len_decode (size_t *out, uint32_t in) {
  *out = (uint32_t) htonl(in);
}


void my_gaps_data_encode(sdh_ha_v1 *p, size_t *p_len, uint8_t *buff_in, size_t *len_out, gaps_tag *tag, codec_map *cmap) {
  uint32_t typ = tag->typ;
  my_type_check(typ, cmap);
  cmap[typ].encode (p->data, buff_in, len_out);
  my_tag_encode(&(p->tag), tag);
  my_len_encode(&(p->data_len), *len_out);
  *p_len = (*len_out) + sizeof(p->tag) + sizeof(p->data_len);
}


/*
 * Decode data from packet
 */
void my_gaps_data_decode(sdh_ha_v1 *p, size_t p_len, uint8_t *buff_out, size_t *len_out, gaps_tag *tag, codec_map *cmap) {
  uint32_t typ = tag->typ;

  /* a) deserialize data from packet */
  my_type_check(typ, cmap);
  my_tag_decode(tag, &(p->tag));
  my_len_decode(len_out, p->data_len);
  cmap[typ].decode (buff_out, p->data, &p_len);
}

void my_xdc_asyn_send(void *socket, void *adu, gaps_tag *tag, codec_map *cmap) {
  sdh_ha_v1    packet, *p=&packet;
  size_t       packet_len;
  
  size_t adu_len;         /* Size of ADU is calculated by encoder */
  my_gaps_data_encode(p, &packet_len, adu, &adu_len, tag, cmap);
  fprintf(stderr, "Before send: %ld\n", packet_len );
  int bytes = zmq_send (socket, (void *) p, packet_len, 0);
  if (bytes <= 0) fprintf(stderr, "send error %s %d ", zmq_strerror(errno), bytes);
}

void my_xdc_blocking_recv(void *socket, void *adu, gaps_tag *tag, codec_map *cmap)
{
    sdh_ha_v1 packet;
    void *p = &packet;

    int size = zmq_recv(socket, p, sizeof(sdh_ha_v1), 0);
    size_t adu_len;
    my_gaps_data_decode(p, size, adu, &adu_len, tag, cmap);
}
void *my_xdc_pub_socket(void *ctx)
{
    int err;
    void *socket;
    socket = zmq_socket(ctx, ZMQ_PUB);
    err = zmq_connect(socket, OUTURI);
    return socket;
}

void *my_xdc_sub_socket(gaps_tag tag, void *ctx)
{
    int err;
    gaps_tag tag4filter;
    void *socket;
    socket = zmq_socket(ctx, ZMQ_SUB);
    err = zmq_connect(socket, INURI);
    my_tag_encode(&tag4filter, &tag);
    err = zmq_setsockopt(socket, ZMQ_SUBSCRIBE, (void *) &tag4filter, RX_FILTER_LEN);
    assert(err == 0);

    return socket;
}

char *my_xdc_set_in(char *addr) {
  int do_once = 1;
  char my_xdc_addr_in[256];
  if (do_once == 1) {
    if (strlen(MY_IPC_ADDR_DEFAULT_IN) >= 255) {
      log_fatal("API IPC_ADDR_DEFAULT_IN too long");
      exit(1);
    }
    strcpy(my_xdc_addr_in, MY_IPC_ADDR_DEFAULT_IN);
    do_once = 0;
  }
  if (addr != NULL) {
    if (strlen(addr) >= 255) {
      log_warn("%s: Input too long, not changing", __func__);
    } else {
      strcpy(my_xdc_addr_in, addr);
    }
  }
  return NULL; //  my_xdc_addr_in; //XXX: return a local array?
}

char *my_xdc_set_out(char *addr) {
  int do_once = 1;
  char my_xdc_addr_out[256];
  if (do_once == 1) {
    if (strlen(MY_IPC_ADDR_DEFAULT_OUT) >= 255) {
      log_fatal("API IPC_ADDR_DEFAULT_IN too long");
      exit(1);
    }
    strcpy(my_xdc_addr_out, MY_IPC_ADDR_DEFAULT_OUT);
    do_once = 0;
    
    /* TODO - Pass logging requirements in as a parameter */
    log_set_quiet(0);
    log_set_level(LOG_INFO);
  }
  if (addr != NULL) {
    if (strlen(addr) >= 255) {
      log_warn("%s: Output too long, not changing", __func__);
    } else {
      strcpy(my_xdc_addr_out, addr);
    }
  }
  return NULL; // my_xdc_addr_out; XXX: Return a local array?
}

void my_tag_write (gaps_tag *tag, uint32_t mux, uint32_t sec, uint32_t typ) {
  tag->mux = mux;
  tag->sec = sec;
  tag->typ = typ;
}

void _hal_init(char *inuri, char *outuri) {
    my_xdc_set_in(inuri);
    my_xdc_set_out(outuri);
    /*
    xdc_register(nextrpc_data_encode, nextrpc_data_decode, DATA_TYP_NEXTRPC);
    xdc_register(okay_data_encode, okay_data_decode, DATA_TYP_OKAY);
    xdc_register(request_recognize_data_encode, request_recognize_data_decode, DATA_TYP_REQUEST_RECOGNIZE);
    xdc_register(response_recognize_data_encode, response_recognize_data_decode, DATA_TYP_RESPONSE_RECOGNIZE);
    xdc_register(request_start_recognizer_data_encode, request_start_recognizer_data_decode, DATA_TYP_REQUEST_START_RECOGNIZER);
    xdc_register(response_start_recognizer_data_encode, response_start_recognizer_data_decode, DATA_TYP_RESPONSE_START_RECOGNIZER);
    xdc_register(request_stop_recognizer_data_encode, request_stop_recognizer_data_decode, DATA_TYP_REQUEST_STOP_RECOGNIZER);
    xdc_register(response_stop_recognizer_data_encode, response_stop_recognizer_data_decode, DATA_TYP_RESPONSE_STOP_RECOGNIZER);
    */
}

void _notify_next_tag(gaps_tag* n_tag) {
    int inited = 0;
    void *psocket;
    void *ssocket;
    gaps_tag t_tag;
    gaps_tag o_tag;
    codec_map  mycmap[MY_DATA_TYP_MAX];
    for (int i=0; i < MY_DATA_TYP_MAX; i++)  mycmap[i].valid=0;
    my_xdc_register(nextrpc_data_encode, nextrpc_data_decode, DATA_TYP_NEXTRPC,mycmap);
    my_xdc_register(okay_data_encode, okay_data_decode, DATA_TYP_OKAY,mycmap);
    my_xdc_register(request_recognize_data_encode, request_recognize_data_decode, DATA_TYP_REQUEST_RECOGNIZE,mycmap);
    my_xdc_register(response_recognize_data_encode, response_recognize_data_decode, DATA_TYP_RESPONSE_RECOGNIZE,mycmap);
    my_xdc_register(request_start_recognizer_data_encode, request_start_recognizer_data_decode, DATA_TYP_REQUEST_START_RECOGNIZER,mycmap);
    my_xdc_register(response_start_recognizer_data_encode, response_start_recognizer_data_decode, DATA_TYP_RESPONSE_START_RECOGNIZER,mycmap);
    my_xdc_register(request_stop_recognizer_data_encode, request_stop_recognizer_data_decode, DATA_TYP_REQUEST_STOP_RECOGNIZER,mycmap);
    my_xdc_register(response_stop_recognizer_data_encode, response_stop_recognizer_data_decode, DATA_TYP_RESPONSE_STOP_RECOGNIZER,mycmap);
    #pragma cle begin TAG_NEXTRPC
    nextrpc_datatype nxt;
    #pragma cle end TAG_NEXTRPC
    my_tag_write(&t_tag, MUX_NEXTRPC, SEC_NEXTRPC, DATA_TYP_NEXTRPC);
    #pragma cle begin TAG_OKAY
    okay_datatype okay;
    #pragma cle end TAG_OKAY
    my_tag_write(&o_tag, MUX_OKAY, SEC_OKAY, DATA_TYP_OKAY);
    if (!inited) {
        inited = 1;
        // psocket = xdc_pub_socket();
        // ssocket = xdc_sub_socket(o_tag);
        // sleep(1); /* zmq socket join delay */
    }
        void * ctx = zmq_ctx_new();
        psocket = my_xdc_pub_socket(ctx);
        ssocket = my_xdc_sub_socket(o_tag,ctx);
        sleep(1); /* zmq socket join delay */

    nxt.mux = n_tag->mux;
    nxt.sec = n_tag->sec;
    nxt.typ = n_tag->typ;
    my_xdc_asyn_send(psocket, &nxt, &t_tag, mycmap);

    sleep(1);
    my_xdc_blocking_recv(ssocket, &okay, &o_tag, mycmap);
    zmq_close(psocket);
    zmq_close(ssocket);
    zmq_ctx_shutdown(ctx);
    // XXX: check that we got valid OK?
}

int _rpc_recognize(double embedding[]) {
    int inited = 0;
    void *psocket;
    void *ssocket;
    gaps_tag t_tag;
    gaps_tag o_tag;
    codec_map  mycmap[MY_DATA_TYP_MAX];
    for (int i=0; i < MY_DATA_TYP_MAX; i++)  mycmap[i].valid=0;
    my_xdc_register(nextrpc_data_encode, nextrpc_data_decode, DATA_TYP_NEXTRPC,mycmap);
    my_xdc_register(okay_data_encode, okay_data_decode, DATA_TYP_OKAY,mycmap);
    my_xdc_register(request_recognize_data_encode, request_recognize_data_decode, DATA_TYP_REQUEST_RECOGNIZE,mycmap);
    my_xdc_register(response_recognize_data_encode, response_recognize_data_decode, DATA_TYP_RESPONSE_RECOGNIZE,mycmap);
    my_xdc_register(request_start_recognizer_data_encode, request_start_recognizer_data_decode, DATA_TYP_REQUEST_START_RECOGNIZER,mycmap);
    my_xdc_register(response_start_recognizer_data_encode, response_start_recognizer_data_decode, DATA_TYP_RESPONSE_START_RECOGNIZER,mycmap);
    my_xdc_register(request_stop_recognizer_data_encode, request_stop_recognizer_data_decode, DATA_TYP_REQUEST_STOP_RECOGNIZER,mycmap);
    my_xdc_register(response_stop_recognizer_data_encode, response_stop_recognizer_data_decode, DATA_TYP_RESPONSE_STOP_RECOGNIZER,mycmap);
    #pragma cle begin TAG_REQUEST_RECOGNIZE
    request_recognize_datatype req_recognize;
    #pragma cle end TAG_REQUEST_RECOGNIZE
    my_tag_write(&t_tag, MUX_REQUEST_RECOGNIZE, SEC_REQUEST_RECOGNIZE, DATA_TYP_REQUEST_RECOGNIZE);
    #pragma cle begin TAG_RESPONSE_RECOGNIZE
    response_recognize_datatype res_recognize;
    #pragma cle end TAG_RESPONSE_RECOGNIZE
    my_tag_write(&o_tag, MUX_RESPONSE_RECOGNIZE, SEC_RESPONSE_RECOGNIZE, DATA_TYP_RESPONSE_RECOGNIZE);
    for(int i=0; i<128; i++) req_recognize.embedding[i] = embedding[i];
    if (!inited) {
        inited = 1;
        // psocket = xdc_pub_socket();
        // ssocket = xdc_sub_socket(o_tag);
        // sleep(1); /* zmq socket join delay */
    }
        void * ctx = zmq_ctx_new();
        psocket = my_xdc_pub_socket(ctx);
        ssocket = my_xdc_sub_socket(o_tag,ctx);
        sleep(1); /* zmq socket join delay */

    my_xdc_asyn_send(psocket, &req_recognize, &t_tag, mycmap);
    my_xdc_blocking_recv(ssocket, &res_recognize, &o_tag, mycmap);
    sleep(1);
    zmq_close(psocket);
    zmq_close(ssocket);
    zmq_ctx_shutdown(ctx);
    return (res_recognize.ret);
}

int _rpc_start_recognizer() {
    int inited = 0;
    void *psocket;
    void *ssocket;
    gaps_tag t_tag;
    gaps_tag o_tag;
    codec_map  mycmap[MY_DATA_TYP_MAX];
    for (int i=0; i < MY_DATA_TYP_MAX; i++)  mycmap[i].valid=0;
    my_xdc_register(nextrpc_data_encode, nextrpc_data_decode, DATA_TYP_NEXTRPC,mycmap);
    my_xdc_register(okay_data_encode, okay_data_decode, DATA_TYP_OKAY,mycmap);
    my_xdc_register(request_recognize_data_encode, request_recognize_data_decode, DATA_TYP_REQUEST_RECOGNIZE,mycmap);
    my_xdc_register(response_recognize_data_encode, response_recognize_data_decode, DATA_TYP_RESPONSE_RECOGNIZE,mycmap);
    my_xdc_register(request_start_recognizer_data_encode, request_start_recognizer_data_decode, DATA_TYP_REQUEST_START_RECOGNIZER,mycmap);
    my_xdc_register(response_start_recognizer_data_encode, response_start_recognizer_data_decode, DATA_TYP_RESPONSE_START_RECOGNIZER,mycmap);
    my_xdc_register(request_stop_recognizer_data_encode, request_stop_recognizer_data_decode, DATA_TYP_REQUEST_STOP_RECOGNIZER,mycmap);
    my_xdc_register(response_stop_recognizer_data_encode, response_stop_recognizer_data_decode, DATA_TYP_RESPONSE_STOP_RECOGNIZER,mycmap);
    #pragma cle begin TAG_REQUEST_START_RECOGNIZER
    request_start_recognizer_datatype req_start_recognizer;
    #pragma cle end TAG_REQUEST_START_RECOGNIZER
    my_tag_write(&t_tag, MUX_REQUEST_START_RECOGNIZER, SEC_REQUEST_START_RECOGNIZER, DATA_TYP_REQUEST_START_RECOGNIZER);
    #pragma cle begin TAG_RESPONSE_START_RECOGNIZER
    response_start_recognizer_datatype res_start_recognizer;
    #pragma cle end TAG_RESPONSE_START_RECOGNIZER
    my_tag_write(&o_tag, MUX_RESPONSE_START_RECOGNIZER, SEC_RESPONSE_START_RECOGNIZER, DATA_TYP_RESPONSE_START_RECOGNIZER);
    req_start_recognizer.dummy = 0;
    if (!inited) {
        inited = 1;
        //psocket = xdc_pub_socket();
        //ssocket = xdc_sub_socket(o_tag);
        //sleep(1); /* zmq socket join delay */
    }
        void * ctx = zmq_ctx_new();
        psocket = my_xdc_pub_socket(ctx);
        ssocket = my_xdc_sub_socket(o_tag,ctx);
        sleep(1); /* zmq socket join delay */

    my_xdc_asyn_send(psocket, &req_start_recognizer, &t_tag, mycmap);

    sleep(1);

    my_xdc_blocking_recv(ssocket, &res_start_recognizer, &o_tag, mycmap);
    zmq_close(psocket);
    zmq_close(ssocket);
    zmq_ctx_shutdown(ctx);
    return (res_start_recognizer.ret);
}

int _rpc_stop_recognizer() {
    int inited = 0;
    void *psocket;
    void *ssocket;
    gaps_tag t_tag;
    gaps_tag o_tag;
    codec_map  mycmap[MY_DATA_TYP_MAX];
    for (int i=0; i < MY_DATA_TYP_MAX; i++)  mycmap[i].valid=0;
    my_xdc_register(nextrpc_data_encode, nextrpc_data_decode, DATA_TYP_NEXTRPC,mycmap);
    my_xdc_register(okay_data_encode, okay_data_decode, DATA_TYP_OKAY,mycmap);
    my_xdc_register(request_recognize_data_encode, request_recognize_data_decode, DATA_TYP_REQUEST_RECOGNIZE,mycmap);
    my_xdc_register(response_recognize_data_encode, response_recognize_data_decode, DATA_TYP_RESPONSE_RECOGNIZE,mycmap);
    my_xdc_register(request_start_recognizer_data_encode, request_start_recognizer_data_decode, DATA_TYP_REQUEST_START_RECOGNIZER,mycmap);
    my_xdc_register(response_start_recognizer_data_encode, response_start_recognizer_data_decode, DATA_TYP_RESPONSE_START_RECOGNIZER,mycmap);
    my_xdc_register(request_stop_recognizer_data_encode, request_stop_recognizer_data_decode, DATA_TYP_REQUEST_STOP_RECOGNIZER,mycmap);
    my_xdc_register(response_stop_recognizer_data_encode, response_stop_recognizer_data_decode, DATA_TYP_RESPONSE_STOP_RECOGNIZER,mycmap);
    #pragma cle begin TAG_REQUEST_STOP_RECOGNIZER
    request_stop_recognizer_datatype req_stop_recognizer;
    #pragma cle end TAG_REQUEST_STOP_RECOGNIZER
    my_tag_write(&t_tag, MUX_REQUEST_STOP_RECOGNIZER, SEC_REQUEST_STOP_RECOGNIZER, DATA_TYP_REQUEST_STOP_RECOGNIZER);
    #pragma cle begin TAG_RESPONSE_STOP_RECOGNIZER
    response_stop_recognizer_datatype res_stop_recognizer;
    #pragma cle end TAG_RESPONSE_STOP_RECOGNIZER
    my_tag_write(&o_tag, MUX_RESPONSE_STOP_RECOGNIZER, SEC_RESPONSE_STOP_RECOGNIZER, DATA_TYP_RESPONSE_STOP_RECOGNIZER);
    req_stop_recognizer.dummy = 0;
    if (!inited) {
        inited = 1;
        //psocket = xdc_pub_socket();
        //ssocket = xdc_sub_socket(o_tag);
        //sleep(1); /* zmq socket join delay */
    }

        void * ctx = zmq_ctx_new();
        psocket = my_xdc_pub_socket(ctx);
        ssocket = my_xdc_sub_socket(o_tag,ctx);
        sleep(1); /* zmq socket join delay */

    my_xdc_asyn_send(psocket, &req_stop_recognizer, &t_tag, mycmap);
    my_xdc_blocking_recv(ssocket, &res_stop_recognizer, &o_tag, mycmap);
    zmq_close(psocket);
    zmq_close(ssocket);
    zmq_ctx_shutdown(ctx);
    return (res_stop_recognizer.ret);
}

void _master_rpc_init() {
    _hal_init((char*)INURI, (char *)OUTURI);
}

