#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <pthread.h>
#include <stdlib.h>
#include <sys/time.h>
#include <errno.h>
#include <ctype.h>

#include "xdcomms.h"
#include "gma.h"

#include "main.h"
#include "utils.h"

flow_head_t *flow_heads = NULL;

int display_interval = 10;         // in seconds

char ipc_pub[MAX_IPC_LEN];
char ipc_sub[MAX_IPC_LEN];

void die(char *s)
{
    printf("%s: %s\n", s, strerror(errno));
    exit(1);
}

unsigned long long get_time()
{
    struct timeval tv;

    gettimeofday(&tv, NULL);

    return  (unsigned long long)(tv.tv_sec) * 1000 +
            (unsigned long long)(tv.tv_usec) / 1000;
}

char *center(char *str, int width, char **dst)
{
    int len = strlen(str);

    if (*dst == NULL) {
        char *buf = malloc(width);
        *dst = buf;

        int offset = (width - len) / 2;
        memset(buf, ' ', width - 1);
        strcpy(buf + offset, str);
        buf[offset + len] = ' ';
        buf[width - 1] = '\0';
    }

    return *dst;
}

/**
 * Return delay in us, given hertz.
 */
long long get_interval(int hz)
{
    if (hz == 0)
        return -1;  // not running the sender

    return (long long) (1000000 / (double) hz);
}

int get_int(char *str)
{
    int i = atoi(str);
    if (i < 0) {
        printf("bad integer %s\n", str);
        usage();
        return -1;
    }

    return i;
}

char *trim(char *str)
{
    char *end;

    while (isspace((unsigned char) *str))
        str++;

    if (*str == 0)  // All spaces?
        return str;

    end = str + strlen(str) - 1;
    while (end > str && isspace((unsigned char) *end))
        end--;

    end[1] = '\0';

    return str;
}

void *init_hal()
{
    void *ctx = xdc_ctx();

    printf("IPC: %s %s\n", my_enclave->pub, my_enclave->sub);

    xdc_set_out(my_enclave->pub);
    xdc_set_in(my_enclave->sub);

    xdc_register(position_data_encode, position_data_decode, DATA_TYP_POSITION);
    xdc_register(distance_data_encode, distance_data_decode, DATA_TYP_DISTANCE);

    return ctx;
}

void init_time(stats_type *nums)
{
    if (nums->start_time != 0)
        return;

    nums->time = get_time();
    nums->last_time = nums->time;
    nums->start_time = nums->time;
}

void close_time(stats_type *nums)
{
    nums->done = 1;
    nums->time = get_time();
}

void encode_timestamp(trailer_datatype *trailer)
{
    unsigned long long curr = get_time();

    trailer->rqr = (curr >> 32);          // high quad
    trailer->oid = (curr & 0xffffffff);   // low quad
}

unsigned long long decode_timestamp(trailer_datatype *trailer)
{
    return ((unsigned long long) trailer->rqr << 32) |
           ((unsigned long long) trailer->oid);
}

void cal_char(stats_type *nums, trailer_datatype *trailer)
{
    time_t recv_time = get_time();
    time_t sent_time = decode_timestamp(trailer);

    // delay
    characteristics_t *delay = &nums->delay;
    double delta = recv_time - sent_time;
    delay->count++;

    if (delta > delay->max)
        delay->max = delta;

    if (delta < delay->min)
        delay->min = delta;

    if (delay->count <= 1)
        delay->avg = delta;
    else {
        delay->avg = (delay->avg * (delay->count - 1) + delta) / delay->count;
    }
    delay->last = delta;

    // jitter
    characteristics_t *jitter = &nums->jitter;


    if (jitter->first) {
        jitter->first = 0;
    }
    else {
        if (trailer->seq - jitter->last_seq == 1) {
            double jdelta = abs(jitter->last - delta);

            jitter->count++;
            if (jitter->count == 1) {
                jitter->avg = jdelta;
                jitter->max = jdelta;
                jitter->min = jdelta;
            }
            else {
                jitter->avg = (jitter->avg * (jitter->count - 1) + jdelta) / jitter->count;

                if (jdelta > jitter->max)
                    jitter->max = jdelta;

                if (jdelta < jitter->min)
                    jitter->min = jdelta;
            }
        }
    }
    jitter->last = delta;
    jitter->last_seq = trailer->seq;

    // loss
    characteristics_t *loss = &nums->loss;
    loss->count++;

    double value = 0;
    if (nums->sender_count > 0) {  // receiver
        double p = (nums->count * 100.0 / nums->sender_count);
        if (p > 100)
            p = 100;
        value = 100 - p;
    }

    if (loss->count <= 1) {
        loss->avg = value;
    }
    else {
        loss->avg = (loss->avg * (loss->count - 1) + value) / loss->count;

        if (value > loss->max)
            loss->max = value;

        if (value < loss->min)
            loss->min = value;
    }
    loss->last = value;
}

//---------------------------------------------- statistics

static void stats_line(flow_t *flow, int type)
{
    stats_type *nums = &flow->stats;

    if (!nums->done)
        nums->time = get_time();

    double elapse_seconds = (nums->time - nums->start_time) / 1000;

    char percentage[16];
    if (nums->sender_count > 0) {  // receiver
        double p = (nums->count * 100.0 / nums->sender_count);
        if (p > 100)
            p = 100;
        sprintf(percentage, "%7.2f", p);
    }
    else if (nums->expected > 0) {
        sprintf(percentage, "%7.2f", (nums->count * 100.0 / nums->expected));
    }
    else
        sprintf(percentage, "%7s", "NA");

    double rate = (elapse_seconds == 0) ? 0 : nums->count / (double) elapse_seconds;
    printf("%4d|%5d %7.2f|%7d %8.2f%s|",
            flow->id,
            (nums->count - nums->last_count),
            (nums->count - nums->last_count) / (double) display_interval,
            nums->count,
            rate,
            percentage);

    printf("%7.2f %7.2f %7.2f|%7.2f %7.2f %7.2f| %7.2f|\n",
            nums->jitter.avg, nums->jitter.max, nums->jitter.min,
            nums->delay.avg, nums->delay.max, nums->delay.min,
            nums->loss.last);
}

static void show_duration(int dir, int type)
{
    int sec, h, m, s;

    unsigned long long ms = 0; // get_time() - stats[dir][type].start_time;

//    if (stats[dir][type].start_time == 0)
//        ms = 0;

    sec = ms / 1000;
    h = (sec / 3600);
    m = (sec - (3600 * h)) / 60;
    s = (sec - (3600 * h) - (m * 60));

    time_t rawtime;
    struct tm *info;
    char buffer[80];

    time(&rawtime);

    info = localtime(&rawtime);

    strftime(buffer, 80, "%H:%M:%S", info);

    printf("current time: %s, \t elapsed time: %02d:%02d:%02d\n", buffer, h, m, s);
}

void show_stats()
{
//    static char *send_ptr = NULL;
//    static char *recv_ptr = NULL;
    static char *inst_ptr = NULL;
    static char *accu_ptr = NULL;
    static char *jitter_ptr = NULL;
    static char *delay_ptr = NULL;
    static char *loss_ptr = NULL;

    show_duration(DIR_SEND, TYPE_POS);

    center("this period", 14, &inst_ptr);
    center("accumulated", 24, &accu_ptr);
    center("jitter (ms)", 24, &jitter_ptr);
    center("delay (ms)", 24, &delay_ptr);
    center("loss (%)", 9, &loss_ptr);

    printf("%4s|%s|%s|%s|%s|%s|\n", " ",
            inst_ptr, accu_ptr, jitter_ptr, delay_ptr, loss_ptr);
    printf("%4s|%6s%7s|%6s%10s%7s|%7s %7s %7s|%7s %7s %7s|%8s|\n", " ",
            "count", "rate", "count", "rate", "%",
            "average", "max", "min",
            "average", "max", "min",
            " ");

    flow_head_t *head = flow_heads;
    while (head != NULL) {
        flow_t *flow = head->flows;
        while (flow != NULL) {
            stats_line(flow, DIR_SEND);

            flow->stats.last_count = flow->stats.count;

            flow = flow->next;
        }

        head = head->next;
    }

    printf("\n");
}

// --------------------------------------------- program initization

static void read_flows(char* flows_filename, char *my_enclave_name)
{
    FILE *fp;
    const int LINE_SIZE = 128;
    char buf[LINE_SIZE];

    if ((fp = fopen(flows_filename, "r")) == NULL) {
        printf("Failed to open config file %s\n", flows_filename);
        exit(EXIT_FAILURE);
    }

    char rate[16], mux[8], sec[8], type[8], port[16];

    flow_head_t *from = NULL, *to = NULL;
    char *enclave = "enclave";
    char *flows = "flows";
    int flow_count = 0;
    while (fgets(buf, LINE_SIZE, fp) != NULL) {
        char *ptr = trim(buf);
        if (strlen(ptr) == 0)
            continue;

        if (ptr[0] == '#') {
            continue;
        }

        if (!strncmp(ptr, enclave, strlen(enclave))) {
            ptr = trim(ptr + strlen(enclave));

            flow_head_t *head = malloc(sizeof(flow_head_t));
            sscanf(ptr, "%s %s %s %s\n", head->enclave, port, head->pub, head->sub);

            head->count = 0;
            head->flows = NULL;
            head->port = get_int(port);
            head->next = flow_heads;

            flow_heads = head;

            if (my_enclave_name != NULL && !strcmp(head->enclave, my_enclave_name)) {
                head->tx = 1;
                my_enclave = head;
            }
        }
        else if (!strncmp(ptr, flows, strlen(flows))) {
            ptr = trim(ptr + strlen(flows));

            char src[16], dst[16];
            sscanf(ptr, "%s %s", src, dst);

            if (flow_heads == NULL)
                die("not enclave defined yet.");

            from = to = NULL;
            flow_head_t *heads = flow_heads;
            while (heads != NULL) {
                if (!strcmp(heads->enclave, src))
                    from = heads;
                else if (!strcmp(heads->enclave, dst))
                    to = heads;

                heads = heads->next;
            }
            if (from == NULL || to == NULL)
                die("no enclave found");
        }
        else if (from == NULL|| to == NULL) {
            die("flow src or dst enclave not found");
        }
        else {
            flow_count++;

            sscanf(ptr, "%s %s %s %s\n", rate, mux, sec, type);
            flow_t *flow = malloc(sizeof(flow_t));
            memset((char *) flow, 0, sizeof(flow_t));

            flow->id = flow_count;
            flow->rate = get_int(rate);
            flow->stats.interval = get_interval(flow->rate);
            flow->mux = get_int(mux);
            flow->sec = get_int(sec);
            flow->type = get_int(type);
            sem_init(&flow->sem, 0, 0);
            flow->next = from->flows;

            from->flows = flow;
            flow->dst = to;
        }
    }
}

void usage()
{
    printf("Usage: <this-program> \n\
\t -h     \t help\n\
\t -v     \t verbose mode\n\
\t -f <recipe>\t Use the flow file\n\
\t -e <enc>\t name of my enclave\n\
\t -l <period>\t Interval in seconds to display statistics in benchmarking (default 10s)\n");
    exit(1);
}

void parse(int argc, char **argv)
{
    char enc[64] = { '\0' };
    char flow_loaded = 0;
    int c;

    while ((c = getopt(argc, argv, "hve:f:l:")) != -1) {
        switch (c) {
        case 'e':
            strcpy(enc, optarg);
            break;
        case 'f':
            read_flows(optarg, enc);
            flow_loaded = 1;
            break;
        case 'h':
            usage();
            break;
        case 'l':
            display_interval = atoi(optarg);
            break;
        case 'v':
            verbose = 1;
            break;
        default:
            usage();
        }
    }

    if (!flow_loaded) {
        printf("using default flow definition: flows.txt\n");
        read_flows("flows.txt", enc);
    }

    if (my_enclave == NULL) {
        if (strlen(enc) == 0) {
            die("Please specify your own enclave using -e");
        }
        flow_head_t *heads = flow_heads;
        while (heads != NULL) {
            if (!strcmp(heads->enclave, enc)) {
                my_enclave = heads;
                break;
            }
            heads = heads->next;
        }
    }

    if (my_enclave == NULL)
        die("Please specify your own enclave using -e");
}
