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
#include <pthread.h>

// Data Annotations
// Circular buffer is on the yellow side and not shareable
// Popped message is not shareable but sanitize returns a shareable copy
 //Information on the source enclave (level yellow) not authorized to be shared with any other enclave
#pragma cle def YELLOW {"level":"yellow"}
 //Information on the source enclave (level red) not authorized to be shared with any other enclave
#pragma cle def RED {"level":"red"}
// Information on the sink enclave (level red) that can be shared with source enclave (level yellow)
#pragma cle def RED_SHAREABLE {"level":"red",\
  "cdf": [\
    {"remotelevel":"yellow", \
     "direction": "egress", \
     "guarddirective": { "operation": "allow"} \
    } \
  ] }
// Information on the source enclave (level yellow) that cget_sink_socket(an be shared with source enclave (level red)
#pragma cle def YELLOW_SHAREABLE {"level":"yellow",\
  "cdf": [\
    {"remotelevel":"red", \
     "direction": "egress", \
     "guarddirective": { "operation": "allow"} \
    } \
  ] }

// Function Annotations
// For each cross domain call the caller and callee must have their respective function annotations
// Any call that is inside the same enclave but changes the taints e.g. from not-shareable to shareable must have a func annotation
// The function annotation of a function called cross domain must have a cdf for every remote side that has that call
// Every function annotation must have a cdf at the same level that the function resides
// Functions called cross domain: 
//CLE: get_sink_socket() on sink / red side, called cross domain from main()
//CLE: update_sink() on sink side called cross domain from pop_source_and_update_sink()
//CLE: shutdown_sink() on sink / red side, called cross domain from main()
//CLE: sanitize() makes non-SHAREABLE data from circular buffer SHAREABLE called from pop_source_and_update_sink()
// define one annotation for each of the 6 functions described above
// functions called cross domain arguments and return value will have the tag_request_FUNC and tag_response_FUNC labels in the corresponding arguments and return taints

// first cdf block is labels i can touch from red
// second cdf block says the function is callable from yellow

#pragma cle def GET_SINK_SOCKET {"level":"red",\
  "cdf": [\
    {"remotelevel":"red", \
     "direction": "egress", \
     "guarddirective": { "operation": "allow"}, \
     "argtaints": [], \
     "codtaints" : ["RED", "RED_SHAREABLE"], \
     "rettaints" : ["RED_SHAREABLE", "TAG_RESPONSE_GET_SINK_SOCKET"] \
    }, \
    {"remotelevel":"yellow", \
     "direction": "egress", \
     "guarddirective": { "operation": "allow"}, \
     "argtaints": [], \
     "codtaints" : ["RED", "RED_SHAREABLE"], \
     "rettaints" : ["RED_SHAREABLE", "TAG_RESPONSE_GET_SINK_SOCKET"] \
    } \
  ] \
}


#pragma cle def UPDATE_SINK {"level":"red",\
  "cdf": [\
    {"remotelevel":"red", \
     "direction": "egress", \
     "guarddirective": { "operation": "allow"}, \
     "argtaints": [["TAG_REQUEST_UPDATE_SINK"], ["TAG_REQUEST_UPDATE_SINK"]], \
     "codtaints" : ["RED", "RED_SHAREABLE", "TAG_RESPONSE_GET_SINK_SOCKET", "TAG_REQUEST_GET_SINK_SOCKET"], \
     "rettaints" : ["TAG_RESPONSE_UPDATE_SINK"] \
    }, \
    {"remotelevel":"yellow", \
     "direction": "egress", \
     "guarddirective": { "operation": "allow"}, \
     "argtaints": [["TAG_REQUEST_UPDATE_SINK"], ["TAG_REQUEST_UPDATE_SINK"]], \
     "codtaints" : ["RED", "RED_SHAREABLE", "TAG_RESPONSE_GET_SINK_SOCKET", "TAG_REQUEST_GET_SINK_SOCKET"], \
     "rettaints" : ["TAG_RESPONSE_UPDATE_SINK"] \
    } \
  ] \
}


#pragma cle def POP_SOURCE_AND_UPDATE_SINK {"level":"yellow",\
  "cdf": [\
    {"remotelevel":"yellow", \
     "direction": "egress", \
     "guarddirective": { "operation": "allow"}, \
     "argtaints": [], \
     "codtaints" : ["YELLOW", "YELLOW_SHAREABLE", "TAG_RESPONSE_UPDATE_SINK", "TAG_REQUEST_UPDATE_SINK"], \
     "rettaints" : ["YELLOW"] \
    } \
  ] \
}


#pragma cle def SHUTDOWN_SINK {"level":"red",\
  "cdf": [\
    {"remotelevel":"red", \
     "direction": "egress", \
     "guarddirective": { "operation": "allow"}, \
     "argtaints": [], \
     "codtaints" : ["RED", "RED_SHAREABLE", "TAG_RESPONSE_GET_SINK_SOCKET", "TAG_REQUEST_GET_SINK_SOCKET"], \
     "rettaints" : ["TAG_RESPONSE_SHUTDOWN_SINK"] \
    }, \
    {"remotelevel":"yellow", \
     "direction": "egress", \
     "guarddirective": { "operation": "allow"}, \
     "argtaints": [], \
     "codtaints" : ["RED", "RED_SHAREABLE", "TAG_RESPONSE_GET_SINK_SOCKET", "TAG_REQUEST_GET_SINK_SOCKET"], \
     "rettaints" : ["TAG_RESPONSE_SHUTDOWN_SINK"] \
    } \
  ] \
}

/* for downstream analysis, argtaint needs TAG_RESPONSE_UPDATE_SINK to
   change san_output to a TAG_RESPONSE for passing to RPC function.
   MK: 10-27-23, see more discussion in code */
#pragma cle def SANITIZE {"level":"yellow",\
  "cdf": [\
    {"remotelevel":"yellow", \
     "direction": "egress", \
     "guarddirective": { "operation": "allow"}, \
     "argtaints": [["YELLOW"], ["YELLOW_SHAREABLE", "TAG_RESPONSE_UPDATE_SINK"], ["YELLOW_SHAREABLE"]], \
     "codtaints" : [], \
     "rettaints" : ["YELLOW"] \
    } \
  ] \
}

#pragma cle def MAIN {"level":"yellow",\
  "cdf": [\
    {"remotelevel":"yellow", \
     "direction": "egress", \
     "guarddirective": { "operation": "allow"}, \
     "argtaints": [], \
     "codtaints" : ["YELLOW", "TAG_RESPONSE_GET_SINK_SOCKET", "TAG_REQUEST_GET_SINK_SOCKET", "TAG_RESPONSE_SHUTDOWN_SINK", "TAG_REQUEST_SHUTDOWN_SINK"], \
     "rettaints" : [] \
    } \
  ] \
}


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


// //CLE: will be annotated to be on source / yellow side and not SHAREABLE

#pragma cle begin YELLOW
struct circular_buffer circ_buff = {
    .cur_size = 0,
    .head = 0,
    .tail = 0
};
#pragma cle end YELLOW

// Getters

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


void print_details() {
    printf("details start\n");
    printf("buffer pointer: %p\n", circ_buff.buffer);
    printf("cur_size: %d\n", circ_buff.cur_size);
    printf("head: %d\n", circ_buff.head);
    printf("tail: %d\n", circ_buff.tail);
    printf("details end\n");
}

void display() {
    printf("%s called\n", __func__);
    print_details();
    for (size_t i = 0; i < circ_buff.cur_size; i++) {
        printf("======== Item %zu start ========\n", i);
        size_t off = (circ_buff.head + i) % NUM_BLOCKS; 
        printf("%*.s\n", circ_buff.block_lengths[off], circ_buff.buffer + (off * BLOCK_SIZE));
        printf("========= Item %zu end =========\n", i);
    }
}

//CLE: source / yellow side
void enqueue(char* input) {
    printf("%s called\n", __func__);
    // print_details();

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
    #pragma cle begin YELLOW
    static bool source_init = false;
    static int source_sock = -1;
    #pragma cle end YELLOW

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

// On the red side
#pragma cle begin GET_SINK_SOCKET
int get_sink_socket() {
#pragma cle end GET_SINK_SOCKET

    static bool sink_init = false;
    #pragma cle begin RED_SHAREABLE
    static int sink_sock = -1;
    #pragma cle end RED_SHAREABLE


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

//CLE: on the source / yellow side
void start_recv_thread() {
    pthread_t id;
    pthread_create(&id, NULL, source_receive, NULL);
    // pthread_join(id, NULL);
}
void inhint(char* ignored, char* input, int len) { }

//CLE: will be on sink / red side
#pragma cle begin UPDATE_SINK
int update_sink(char* output, int len) {
#pragma cle end UPDATE_SINK
    inhint(output, output, BLOCK_SIZE);
    if (send(get_sink_socket(), output, len, 0) < 0) {
        perror("send\n");
        exit(1);
    }
    return 0;
}

//CLE: this function makes non-SHAREABLE input to SHAREABLE return
#pragma cle begin SANITIZE
void sanitize(char* input, char* output, int len) {
#pragma cle end SANITIZE
    strncpy(output, input, len); // can do filtering on input here if needed.
}

// ask if this function could result in a thread issue.
#pragma cle begin POP_SOURCE_AND_UPDATE_SINK
void pop_source_and_update_sink() {
#pragma cle end POP_SOURCE_AND_UPDATE_SINK
    // printf("%s called\n", __func__);
    #pragma cle begin YELLOW
    char output[BLOCK_SIZE];
    #pragma cle end YELLOW
    /* MK 10-27-23: san_output gets reassigned as TAG_REQUEST_UPDATE_SINK in downstream
    conflict_analysis. Uncommented YELLOW_SHAREABLE for now. Downstream 
    assigns different annotation to something that was a different annotation
    upstream (i.e., when below is uncommented). This is a larger problem.
    
    conflict otherwise arises in:
            sanitize(output, san_output, len);
            update_sink(san_output, len);
    */
    // #pragma cle begin YELLOW_SHAREABLE
    char san_output[BLOCK_SIZE];
    // #pragma cle end YELLOW_SHAREABLE
    while(1) {
        memset(output, 0, sizeof(output));
        memset(san_output, 0, sizeof(san_output));
        #pragma cle begin YELLOW_SHAREABLE
        // is this thread safe?
        int len = circ_buff.block_lengths[circ_buff.head];
        #pragma cle end YELLOW_SHAREABLE
        if (len != 0) {
            printf("Len isnt 0\n");
            memcpy(output, head(), head_len());
            // ensure that pop is the only function modifying head and head_len 
            // only this thread calls pop
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
#pragma cle begin SHUTDOWN_SINK
int shutdown_sink() {
#pragma cle end SHUTDOWN_SINK
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
//CLE: circular buffer is source side not SHAREABLE
//CLE: sanitize() makes non-SHAREABLE data from circular buffer SHAREABLE.
//CLE: shutdown_source() on source / yellow side
//CLE: shutdown_sink() on sink / red side, called cross domain
//CLE: main on source side
#pragma cle begin MAIN
int main() {    
#pragma cle end MAIN
    init_buffer();
    get_source_socket();
    get_sink_socket(); //GEDL generator and downstream tools failing: when fixed we can uncomment
    start_recv_thread();
    pop_source_and_update_sink();
    shutdown_source();
    shutdown_sink();
    return 0;
}
