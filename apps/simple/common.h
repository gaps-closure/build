#pragma once
#include <signal.h>

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

typedef struct _stats {
    long long delay;
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
} stats_type;

extern stats_type stats[][NUM_TYPES];

extern pthread_mutex_t recv_lock;
extern pthread_mutex_t send_lock;

extern char benchmarking;
extern char ipc_pub[];
extern char ipc_sub[];

void *benchmark();
void show_stats();
void init_locks();
void usage();
void parse(int argc, char **argv);
void *init_hal();
void *gaps_write(uint32_t t_mux, uint32_t t_sec, uint32_t type, int port);
void *gaps_read(uint32_t t_mux, uint32_t t_sec, uint32_t type, int port);
int pong_sender(int port, int *to_recv);
int ping_receiver(int port, int to_send);
void update_receiver(int sock, int port, int count);
int update_from_sender(int sock);
void sig_handler(int signo);
void init_stats(int delay_dis, int delay_pos);
