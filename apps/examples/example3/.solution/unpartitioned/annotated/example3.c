#include <stdio.h>
#include <time.h>
#pragma cle def PURPLE {"level":"purple"}

#pragma cle def ORANGE {"level":"orange",\
  "cdf": [\
    {"remotelevel":"purple", \
     "direction": "egress", \
     "guarddirective": { "operation": "allow"}}\
  ] }

#pragma cle def XDLINKAGE_GET_A {"level":"orange",\
  "cdf": [\
    {"remotelevel":"purple", \
     "direction": "bidirectional", \
     "guarddirective": { "operation": "allow"}, \
     "argtaints": [], \
     "codtaints": ["ORANGE"], \
     "rettaints": ["TAG_RESPONSE_GET_A"] \
    } \
  ] }
#pragma cle begin XDLINKAGE_GET_A 
double fib(i) {
#pragma cle end XDLINKAGE_GET_A 
#pragma cle begin ORANGE
  static int mod = 100000007;
  #pragma cle end ORANGE
  i++;
  if (i < 2) {
    return 1;
  }
  int one = 1;
  int two = 1;
  for(int j = 2; j < i; j++) {
    int temp = one;
    one = (one + two) % mod;
    two = temp;
  }
  return one;
}
int fib_main() {
  #pragma cle begin PURPLE
  double x;
  #pragma cle end PURPLE
  int msec = 0;
  clock_t before = clock();
  for (int i= 0; i < 1000; i++) {
     x = fib(i);
     if(i % 100 == 0) {
         clock_t difference = clock() - before;
        msec = difference * 1000 / CLOCKS_PER_SEC;
       printf("%f %d\n", x, msec);
     }
  }
  before = clock();
  for (int i= 0; i < 1000; i++) {
     x = fib(i);
     if(i % 100 == 0) {
         clock_t difference = clock() - before;
        msec = difference * 1000 / CLOCKS_PER_SEC;
       printf("%f %d\n", x, msec);
     }
  }

  return 0;
}



int main() {
  return fib_main(); 
}

