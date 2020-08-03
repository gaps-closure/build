#include "purple_rpc.h"
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

void my_tag_write (gaps_tag *tag, uint32_t mux, uint32_t sec, uint32_t typ) {
  tag->mux = mux;
  tag->sec = sec;
  tag->typ = typ;
}

void _handle_nextrpc(gaps_tag* n_tag) {
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
    #pragma cle begin TAG_OKAY
    okay_datatype okay;
    #pragma cle end TAG_OKAY
    my_tag_write(&t_tag, MUX_NEXTRPC, SEC_NEXTRPC, DATA_TYP_NEXTRPC);
    void * ctx = zmq_ctx_new();
    psocket = my_xdc_pub_socket(ctx);
    ssocket = my_xdc_sub_socket(t_tag,ctx);
    sleep(1); /* zmq socket join delay */

    my_xdc_blocking_recv(ssocket, &nxt, &t_tag, mycmap);
    my_tag_write(&o_tag, MUX_OKAY, SEC_OKAY, DATA_TYP_OKAY);
    okay.x = 0;
    my_xdc_asyn_send(psocket, &okay, &o_tag, mycmap);
    zmq_close(psocket);
    zmq_close(ssocket);
    zmq_ctx_shutdown(ctx);
    n_tag->mux = nxt.mux;
    n_tag->sec = nxt.sec;
    n_tag->typ = nxt.typ;
}

void _handle_request_recognize(gaps_tag* tag) {
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
    void * ctx = zmq_ctx_new();
    psocket = my_xdc_pub_socket(ctx);
    ssocket = my_xdc_sub_socket(t_tag,ctx);
    sleep(1); /* zmq socket join delay */
    my_xdc_blocking_recv(ssocket, &req_recognize, &t_tag, mycmap);
    res_recognize.ret = recognize(req_recognize.embedding);
    my_xdc_asyn_send(psocket, &res_recognize, &o_tag, mycmap);
    zmq_close(psocket);
    zmq_close(ssocket);
    zmq_ctx_shutdown(ctx);
}

void _handle_request_start_recognizer(gaps_tag* tag) {
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
    void * ctx = zmq_ctx_new();
    psocket = my_xdc_pub_socket(ctx);
    ssocket = my_xdc_sub_socket(t_tag,ctx);
    sleep(1); /* zmq socket join delay */

    my_xdc_blocking_recv(ssocket, &req_start_recognizer, &t_tag, mycmap);
    res_start_recognizer.ret = start_recognizer();
    my_xdc_asyn_send(psocket, &res_start_recognizer, &o_tag, mycmap);
    zmq_close(psocket);
    zmq_close(ssocket);
    zmq_ctx_shutdown(ctx);
}

void _handle_request_stop_recognizer(gaps_tag* tag) {
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
    void * ctx = zmq_ctx_new();
    psocket = my_xdc_pub_socket(ctx);
    ssocket = my_xdc_sub_socket(t_tag,ctx);
    sleep(1); /* zmq socket join delay */

    my_xdc_blocking_recv(ssocket, &req_stop_recognizer, &t_tag, mycmap);
    res_stop_recognizer.ret = stop_recognizer();
    my_xdc_asyn_send(psocket, &res_stop_recognizer, &o_tag, mycmap);
    zmq_close(psocket);
    zmq_close(ssocket);
    zmq_ctx_shutdown(ctx);
}

#define NXDRPC 4
WRAP(nextrpc)
WRAP(request_recognize)
WRAP(request_start_recognizer)
WRAP(request_stop_recognizer)

int _slave_rpc_loop() {
    gaps_tag n_tag;
    pthread_t tid[NXDRPC];
    pthread_create(&tid[0], NULL, _wrapper_nextrpc, &n_tag);
    pthread_create(&tid[1], NULL, _wrapper_request_recognize, &n_tag);
    pthread_create(&tid[2], NULL, _wrapper_request_start_recognizer, &n_tag);
    pthread_create(&tid[3], NULL, _wrapper_request_stop_recognizer, &n_tag);
    for (int i = 0; i < NXDRPC; i++) pthread_join(tid[i], NULL);
    return 0;
}
