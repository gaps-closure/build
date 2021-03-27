#include "example2_rpc.h"


int hash_code(request_fib_datatype req, int size) {
	int seed = 1;
	seed = (seed * (req.trailer.crc == 0) ? req.trailer.crc : 1) % size;
	seed = (seed *(req.trailer.seq == 0) ? req.trailer.seq : 1) % size;
	seed = (seed * (req.trailer.rqr == 0) ? req.trailer.rqr : 1) % size;
	seed = (seed * (req.trailer.oid == 0) ? req.trailer.oid : 1) % size;
	seed = (seed *(req.trailer.mid == 0) ? req.trailer.mid : 1) % size;
	seed = (seed * req.i) % size;
	printf("Seed is %d\n", seed);
	return seed;
	
}

typedef struct hash_set {
	char* type;
	void* data;
};


double _rpc_fib(int i) {
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
	static struct hash_set* hashmap;
	static int size = 1000000;
	req_fib.i=i;
	if(hashmap == NULL) {
		hashmap = malloc(size*sizeof(hashmap));
	}
	int code = hash_code(req_fib, size);
	if(hashmap[code].data != NULL ) {
		printf("Cache Hit \n");
		double* pointer = ((double*) hashmap[code].data);
		return *pointer;
	}


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

	hashmap[code].data = malloc(sizeof(double));
	*((double*) hashmap[code].data) = res_fib.ret;
	printf("Inserted %f\n", *((double*) hashmap[code].data));
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

