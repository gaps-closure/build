#ifdef _cplusplus
extern "C" {
#endif /* _cplusplus */

#ifndef GMA_HEADER_FILE
#define GMA_HEADER_FILE

#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <inttypes.h>
#include <arpa/inet.h>
#include <float.h>

#include "float754.h"

#define codec_id(X) (X)

#pragma pack(push,1)
typedef struct _trailer_datatype {
  uint32_t seq;
  uint32_t rqr;
  uint32_t oid;
  uint16_t mid;
  uint16_t crc;
} trailer_datatype;
#pragma pack(pop)

#ifndef TYP_BASE
#define TYP_BASE 0
#endif /* TYP_BASE */
#define DATA_TYP_NEXTRPC TYP_BASE + 1
#define DATA_TYP_OKAY TYP_BASE + 2
#define DATA_TYP_REQUEST_GET_A TYP_BASE + 3
#define DATA_TYP_RESPONSE_GET_A TYP_BASE + 4

#pragma pack(push,1)
typedef struct _nextrpc_datatype {
  int32_t mux;
  int32_t sec;
  int32_t typ;
  trailer_datatype trailer;
} nextrpc_datatype;
#pragma pack(pop)

#pragma pack(push,1)
typedef struct _nextrpc_output {
  int32_t mux;
  int32_t sec;
  int32_t typ;
  trailer_datatype trailer;
} nextrpc_output;
#pragma pack(pop)

#pragma pack(push,1)
typedef struct _okay_datatype {
  int32_t x;
  trailer_datatype trailer;
} okay_datatype;
#pragma pack(pop)

#pragma pack(push,1)
typedef struct _okay_output {
  int32_t x;
  trailer_datatype trailer;
} okay_output;
#pragma pack(pop)

#pragma pack(push,1)
typedef struct _request_get_a_datatype {
  int32_t dummy;
  trailer_datatype trailer;
} request_get_a_datatype;
#pragma pack(pop)

#pragma pack(push,1)
typedef struct _request_get_a_output {
  int32_t dummy;
  trailer_datatype trailer;
} request_get_a_output;
#pragma pack(pop)

#pragma pack(push,1)
typedef struct _response_get_a_datatype {
  double ret;
  trailer_datatype trailer;
} response_get_a_datatype;
#pragma pack(pop)

#pragma pack(push,1)
typedef struct _response_get_a_output {
  uint64_t ret;
  trailer_datatype trailer;
} response_get_a_output;
#pragma pack(pop)

extern void nextrpc_print (nextrpc_datatype *nextrpc);
extern void nextrpc_data_encode (void *buff_out, void *buff_in, size_t *len_out);
extern void nextrpc_data_decode (void *buff_out, void *buff_in, size_t *len_in);

extern void okay_print (okay_datatype *okay);
extern void okay_data_encode (void *buff_out, void *buff_in, size_t *len_out);
extern void okay_data_decode (void *buff_out, void *buff_in, size_t *len_in);

extern void request_get_a_print (request_get_a_datatype *request_get_a);
extern void request_get_a_data_encode (void *buff_out, void *buff_in, size_t *len_out);
extern void request_get_a_data_decode (void *buff_out, void *buff_in, size_t *len_in);

extern void response_get_a_print (response_get_a_datatype *response_get_a);
extern void response_get_a_data_encode (void *buff_out, void *buff_in, size_t *len_out);
extern void response_get_a_data_decode (void *buff_out, void *buff_in, size_t *len_in);

#endif /* GMA_HEADER_FILE */

#ifdef _cplusplus
}
#endif /* _cplusplus */
