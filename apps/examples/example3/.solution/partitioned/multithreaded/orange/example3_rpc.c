#include "example3_rpc.h"
#define TAG_MATCH(X, Y) (X.mux == Y.mux && X.sec == Y.sec && X.typ == Y.typ)
#define WRAP(X) void *_wrapper_##X(void *tag) { while(1) { _handle_##X(tag); } }

void _handle_request_fib(gaps_tag* tag) {
	static int inited = 0;
	static void *psocket;
	static void *ssocket;
	gaps_tag t_tag;
	gaps_tag o_tag;
	#pragma cle begin TAG_REQUEST_FIB
	request_fib_datatype req_fib;
	#pragma cle end TAG_REQUEST_FIB
	#pragma cle begin TAG_RESPONSE_FIB
	response_fib_datatype res_fib;
	#pragma cle end TAG_RESPONSE_FIB

	tag_write(&t_tag, MUX_REQUEST_FIB, SEC_REQUEST_FIB, DATA_TYP_REQUEST_FIB);
	if(!inited) {
		inited = 1;
		psocket = xdc_pub_socket();
		ssocket = xdc_sub_socket(t_tag);
		sleep(1); /* zmq socket join delay */
	}

	xdc_blocking_recv(ssocket, &req_fib, &t_tag);
	res_fib.ret = fib(req_fib.i);

	tag_write(&o_tag, MUX_RESPONSE_FIB, SEC_RESPONSE_FIB, DATA_TYP_RESPONSE_FIB);
	xdc_asyn_send(psocket, &res_fib, &o_tag);
}

void _handle_nxtrpc(gaps_tag* n_tag) {
	static int inited = 0;
	static void *psocket;
	static void *ssocket;
	gaps_tag t_tag;
	gaps_tag o_tag;
	#pragma cle begin TAG_NEXTRPC
	nextrpc_datatype nxt;
	#pragma cle end TAG_NEXTRPC
	#pragma cle begin TAG_OKAY
	okay_datatype okay;
	#pragma cle end TAG_OKAY

	tag_write(&t_tag, MUX_NEXTRPC, SEC_NEXTRPC, DATA_TYP_NEXTRPC);
	if(!inited) {
		inited = 1;
		psocket = xdc_pub_socket();
		ssocket = xdc_sub_socket(t_tag);
		sleep(1); /* zmq socket join delay */
	}

	xdc_blocking_recv(ssocket, &nxt, &t_tag);

	tag_write(&o_tag, MUX_OKAY, SEC_OKAY, DATA_TYP_OKAY);
	okay.x = 0;
	xdc_asyn_send(psocket, &okay, &o_tag);

	n_tag->mux = nxt.mux;
	n_tag->sec = nxt.sec;
	n_tag->typ = nxt.typ;
}

void _hal_init(char *inuri, char *outuri) {
	xdc_set_in(inuri);
	xdc_set_out(outuri);
	xdc_register(nextrpc_data_encode, nextrpc_data_decode, DATA_TYP_NEXTRPC);
	xdc_register(okay_data_encode, okay_data_decode, DATA_TYP_OKAY);
	xdc_register(request_fib_data_encode, request_fib_data_decode, DATA_TYP_REQUEST_FIB);
	xdc_register(response_fib_data_encode, response_fib_data_decode, DATA_TYP_RESPONSE_FIB);
}

#define NXDRPC 2
WRAP(nxtrpc)
WRAP(request_fib)

int _slave_rpc_loop() {
	gaps_tag n_tag;
	pthread_t tid[NXDRPC];
	_hal_init((char *)INURI, (char *)OUTURI);
	pthread_create(&tid[0], NULL, _wrapper_nxtrpc, &n_tag);
	pthread_create(&tid[1], NULL, _wrapper_request_fib, &n_tag);
	for (int i = 0; i < NXDRPC; i++) pthread_join(tid[i], NULL);
	return 0;
}

