#ifndef XDC_HEADER_FILE
#define XDC_HEADER_FILE

#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include <zmq.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <assert.h>

#define ADU_SIZE_MAX_C  200
#define PACKET_MAX      2048
#define RX_FILTER_LEN   12
#define DATA_TYP_MAX    200

#define IPC_ADDR_DEFAULT_IN  "ipc:///tmp/halpub1"
#define IPC_ADDR_DEFAULT_OUT "ipc:///tmp/halsub1"
/**********************************************************************/
/* LIB Structures */
/*********t************************************************************/
/* Closure tag structure */
typedef struct _tag {
  uint32_t    mux;      /* APP ID */
  uint32_t    sec;      /* Security tag */
  uint32_t    typ;      /* data type */
} gaps_tag;

/* CLOSURE packet */
typedef struct _sdh_ha_v1 {
  gaps_tag  tag;
  uint32_t  data_len;
  uint8_t   data[ADU_SIZE_MAX_C];
} sdh_ha_v1;

/* Map of (encode and decode) function pointers for each data type */

/* (Data type is the index into the codec_map) */
typedef void (*codec_func_ptr)(void *, void *, size_t *);
typedef struct _codec_map {
  int valid;
  codec_func_ptr encode;
  codec_func_ptr decode;
} codec_map;
extern codec_map  cmap[DATA_TYP_MAX];

/* Minor exposed function prototypes */
extern void tag_print (gaps_tag *);
extern void data_print(const char *, uint8_t *, size_t);
extern void tag_write (gaps_tag *, uint32_t,   uint32_t,   uint32_t);
extern void tag_read  (gaps_tag *, uint32_t *, uint32_t *, uint32_t *);
extern void tag_encode (gaps_tag *, gaps_tag *);
extern void tag_decode (gaps_tag *, gaps_tag *);
extern void len_encode (uint32_t *, size_t);
extern void len_decode (size_t *, uint32_t);

// Main HAL API functions
extern void xdc_register(codec_func_ptr encoder, codec_func_ptr decoder, int type);
extern void xdc_asyn_sendX(void *send_buf, gaps_tag tag);
extern void xdc_blocking_recvX(void *recv_buf, gaps_tag *tag);
extern char *xdc_set_in(char *);  /* addr = NULL returns current value, non-NULL sets the value */
extern char *xdc_set_out(char *);

extern void *xdc_ctx();
extern void *xdc_pub_socket(void *ctx);
extern void *xdc_sub_socket(gaps_tag tag);

extern void xdc_asyn_send(void *socket, void *adu, gaps_tag tag);
extern void xdc_blocking_recv(void *socket, void *adu, gaps_tag *tag);

#endif
