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
int fib_main() {
#pragma clang attribute push (__attribute__((annotate("PURPLE"))), apply_to = any(function,type_alias,record,enum,variable,field))
  #pragma cle begin PURPLE
  double x;
  #pragma cle end PURPLE
#pragma clang attribute pop
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

