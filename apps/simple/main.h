#pragma once
#include <signal.h>
#include <semaphore.h>

#define MAX_IPC_LEN     64
#define MAX_PKT_LEN     2048

#define PORT_ORANGE_TO_GREEN_DIS  9001
#define PORT_ORANGE_TO_GREEN_POS  9003

#define PORT_GREEN_TO_ORANGE_DIS  9002
#define PORT_GREEN_TO_ORANGE_POS  9004

#define DIR_SEND   0
#define DIR_RECV   1
#define NUM_DIRS   2

#define TYPE_DIS   0
#define TYPE_POS   1
#define TYPE_TOTAL 2
#define NUM_TYPES  3

typedef struct _characteristics_t {
    double max;
    double min;
    double avg;
    double last;
    int count;
    int last_seq;
    char first;
} characteristics_t;

typedef struct _stats {
    long long interval;
    int expected;                   // number of pkts expected to send or receive
    int count;                      // current count of sent or received pkts
    int sender_count;               // sender's count received out of band
    int last_count;                 // count of sent or received pkts in the last period
    unsigned long long time;        // current time in ms
    unsigned long long last_time;   // time of the last period in ms
    unsigned long long start_time;  // start time of the thread in ms
    char done;                      // 1 for complete; 0 otherwise
    int port;                       // UDP port to wait or send out-of-band data
    int sock;                       // socket for out-of-band data
    pthread_t thread;               // thread associated with this flow

    characteristics_t delay;
    characteristics_t jitter;
    characteristics_t loss;
} stats_type;

typedef struct _flow_t {
    int id;
    int rate;
    int mux;
    int sec;
    int type;
    char ready;
    char done;
    unsigned long long last_update;
    sem_t sem;
    stats_type stats;
    struct _flow_head_t *dst;
    struct _flow_t *next;
} flow_t;

typedef struct _flow_head_t {
    char enclave[16];
    char pub[64];
    char sub[64];
    char tx;
    int port;
    int count;
    flow_t *flows;
    struct _flow_head_t *next;
} flow_head_t;

extern stats_type stats[][NUM_TYPES];

extern pthread_mutex_t recv_lock;
extern pthread_mutex_t send_lock;
extern flow_head_t *my_enclave;
extern char verbose;

void die(char *s);
void *benchmark();

void update_receiver(int sock, int port, int count);
int update_from_sender(int sock);
