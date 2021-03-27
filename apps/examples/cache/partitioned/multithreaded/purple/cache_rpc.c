#include "cache_rpc.h"
double _rpc_fib() {
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

	req_fib.dummy = 0;
	tag_write(&t_tag, MUX_REQUEST_FIB, SEC_REQUEST_FIB, DATA_TYP_REQUEST_FIB);
	tag_write(&o_tag, MUX_RESPONSE_FIB, SEC_RESPONSE_FIB, DATA_TYP_RESPONSE_FIB);

	if(!inited) {
		inited = 1;
		psocket = xdc_pub_socket();
		ssocket = xdc_sub_socket(o_tag);
		sleep(1); /* zmq socket join delay */
	}

	xdc_asyn_send(psocket, &req_fib, &t_tag);
	xdc_blocking_recv(ssocket, &res_fib, &o_tag);
	return (res_fib.ret);
}

void _hal_init(char *inuri, char *outuri) {
	xdc_set_in(inuri);
	xdc_set_out(outuri);
	xdc_register(nextrpc_data_encode, nextrpc_data_decode, DATA_TYP_NEXTRPC);
	xdc_register(okay_data_encode, okay_data_decode, DATA_TYP_OKAY);
	xdc_register(request_fib_data_encode, request_fib_data_decode, DATA_TYP_REQUEST_FIB);
	xdc_register(response_fib_data_encode, response_fib_data_decode, DATA_TYP_RESPONSE_FIB);
}

void _master_rpc_init() {
	_hal_init((char*)INURI, (char *)OUTURI);
}

