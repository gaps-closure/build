#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/select.h> 
#include <arpa/inet.h>
#include <netinet/in.h>
#include <unistd.h> 
#include <pthread.h>
#include <string.h>
#include <time.h>

#define HOST "127.0.0.1"
#define PORT 8087

#define BLOCK_SIZE 1024 
#define NUM_BLOCKS 64 

struct circular_buffer {
    pthread_mutex_t lock; // acquire lock before reading or writing any block then release
    char* buffer; //total memory for all blocks = block_size * num_blocks
    int* block_lengths; //num_blocks sized array containing the length of each block 
    int cur_size; // number of blocks currently used
    int head; //index of the head of the queue in the circular buffer [0:num_blocks - 1]
    int tail; //index of the tail of the queue in the circular buffer [0:num_blocks - 1]
};


// //CLE: will be annotated to be on source / yellow side and not sharable
struct circular_buffer circ_buff = {
    .cur_size = 0,
    .head = 0,
    .tail = 0
};

char* head() {
    return circ_buff.buffer + (circ_buff.head * BLOCK_SIZE);
}

char* tail() {
    return circ_buff.buffer + (circ_buff.tail * BLOCK_SIZE);
}

int head_len() {
    return circ_buff.block_lengths[circ_buff.head];
}

int tail_len() {
    return circ_buff.block_lengths[circ_buff.tail];
}

void init_lock() {
    pthread_mutex_init(&circ_buff.lock, NULL); 
}


//CLE: source / yellow side
void init_buffer() {
    init_lock();

    circ_buff.buffer = (char*) malloc(NUM_BLOCKS * BLOCK_SIZE * sizeof(char));
    memset(circ_buff.buffer, 0, NUM_BLOCKS * BLOCK_SIZE * sizeof(char));

    circ_buff.block_lengths = (int*) malloc(NUM_BLOCKS * sizeof(int));
    memset(circ_buff.block_lengths, 0, NUM_BLOCKS * sizeof(int));
}

//CLE: source / yellow side
void enqueue(char* input) {
    printf("%s called\n", __func__);

    pthread_mutex_lock(&circ_buff.lock);
    if (strlen(input) > BLOCK_SIZE) {
        printf("Unable to enqueue input greater than block size %d\n", BLOCK_SIZE);
    }
    else if (circ_buff.cur_size < NUM_BLOCKS) {
        circ_buff.block_lengths[circ_buff.tail] = strlen(input);
        strncpy(tail(), input, tail_len());
        printf("This is added to the buffer: %.*s\n", 
            tail_len(),
            tail()
        );
        circ_buff.tail = (circ_buff.tail + 1) % NUM_BLOCKS;
        circ_buff.cur_size++;
    }
    else {
        printf("Buffer is full. Input not queued.\n");
    }
    pthread_mutex_unlock(&circ_buff.lock);
}

//CLE: source / yellow side
void pop() {
    printf("%s called\n", __func__);
    pthread_mutex_lock(&circ_buff.lock);
    if (circ_buff.cur_size == 0) {
        printf("empty pop\n");
        pthread_mutex_unlock(&circ_buff.lock);
        return;
    }

    printf("popped %*.s\n", head_len(), head());
    circ_buff.cur_size = circ_buff.cur_size - 1;
    circ_buff.block_lengths[circ_buff.head] = 0;
    circ_buff.head = (circ_buff.head + 1) % NUM_BLOCKS;
    pthread_mutex_unlock(&circ_buff.lock);
}

//CLE: source / yellow side
int get_source_socket() {
    static bool source_init = false;
    static int source_sock = -1;

    if (source_init) {
        return source_sock;
    }

    struct sockaddr_in source_addr;
    source_addr.sin_family = AF_INET;
    source_addr.sin_port = htons(PORT);
    source_addr.sin_addr.s_addr = inet_addr(HOST);

    source_sock = socket(AF_INET, SOCK_STREAM, 0);

    if (source_sock == -1) {
        perror("socket");
        exit(1);
    }
    if (connect(source_sock, (struct sockaddr *) &source_addr, sizeof(source_addr)) < 0) {
        perror("connect");
        exit(1);
    }

    source_init = true;
    return source_sock;
}

//CL: sink / red side
int get_sink_socket() {
    static bool sink_init = false;
    static int sink_sock = -1;

    if (sink_init) {
        return sink_sock;
    }

    struct sockaddr_in sink_addr;
    sink_addr.sin_family = AF_INET;
    sink_addr.sin_port = htons(PORT);
    sink_addr.sin_addr.s_addr = inet_addr(HOST);

    sink_sock = socket(AF_INET, SOCK_STREAM, 0);

    if (sink_sock == -1) {
        perror("socket");
        exit(1);
    }
    if (connect(sink_sock, (struct sockaddr *) &sink_addr, sizeof(sink_addr)) < 0) {
        perror("connect");
        exit(1);
    }

    sink_init = true;
    return sink_sock;
}

char* split(char *str, const char *delim) {
    char *p = strstr(str, delim);
    if (p == NULL) return NULL;     // delimiter not found
    *p = '\0';                      // terminate string after head
    return p + strlen(delim);       // return tail substring
}

void* source_receive() {
    int sock = -1; 
    sock = get_source_socket();
    char server_response[4096];
    char delimiter[] = "ent>";
    char event[1024];
    char* tail;

    while (1) {
        memset(server_response, 0, sizeof(server_response));
        memset(event, 0, sizeof(event));

        if (recv(sock, &server_response, sizeof(server_response), 0) < 0) {
            perror("recv");
            exit(1);
        }
        printf("%s : Received information\n", __func__);
        printf("%s\n", server_response);

        tail = split(server_response, delimiter);
        while (tail) {
            strcpy(event, server_response);
            strcat(event, delimiter);
            enqueue(event);
            strcpy(server_response, tail);
            tail = split(server_response, delimiter);
        }
        usleep(200000);
    }
}

//CLE: source / yellow side
void start_recv_thread() {
    pthread_t id;
    pthread_create(&id, NULL, source_receive, NULL);
}

void inhint(char* ignored, char* input, int len) { }

//CLE: sink / red side
int update_sink(char* output, int len) {
    inhint(output, output, BLOCK_SIZE);
    if (send(get_sink_socket(), output, len, 0) < 0) {
        perror("send\n");
        exit(1);
    }
    return 0;
}

//CLE: this function makes non-sharable input to sharable return
void sanitize(char* input, char* output, int len) {
    strncpy(output, input, len); // can do filtering on input here if needed.
}

void pop_source_and_update_sink() {
    char output[BLOCK_SIZE];
    char san_output[BLOCK_SIZE];
    while(1) {
        memset(output, 0, sizeof(output));
        memset(san_output, 0, sizeof(san_output));
        int len = circ_buff.block_lengths[circ_buff.head];
        if (len != 0) {
            printf("Len isnt 0\n");
            memcpy(output, head(), head_len());
            pop();
            sanitize(output, san_output, len);
            update_sink(san_output, len);
        }
        usleep(200000);
    }
}

//CLE: source / yellow side
void shutdown_source() {
    int source_sock = -1;
    if ((source_sock = get_source_socket()) != -1) {
        close(source_sock);
    }

    for (int i = 0; i < NUM_BLOCKS; i++) {
        memset(&circ_buff.buffer[i * BLOCK_SIZE], 0, BLOCK_SIZE);
        memset(&circ_buff.block_lengths[i], 0, BLOCK_SIZE);
    }
    free(circ_buff.buffer);
    free(circ_buff.block_lengths);
}

//CLE: sink / red side
int shutdown_sink() {
    int sink_sock = -1;
    if ((sink_sock = get_sink_socket()) != -1) {
        close(sink_sock);
    }
    return 0;
}

//CLE: init_buffer() on source / yellow side
//CLE: get_source_socket() on source / yellow side
//CLE: get_sink_socket() on sink / red side, called cross domain
//CLE: start_recv_thread() on source / yellow side
//CLE: pop_source_update_sink() on source side calls update_sink()
//CLE: update_sink() on sink side called cross domain
//CLE: circular buffer is source side not sharable
//CLE: sanitize() makes non-sharable data from circular buffer sharable.
//CLE: shutdown_source() on source / yellow side
//CLE: shutdown_sink() on sink / red side, called cross domain
//CLE: main on source side
int main() {
    init_buffer();
    get_source_socket();
    get_sink_socket();
    start_recv_thread();
    pop_source_and_update_sink();
    shutdown_source();
    shutdown_sink();
    return 0;
}