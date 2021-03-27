#include "example2_rpc.h"
#include <stdio.h>

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

#pragma clang attribute push (__attribute__((annotate("XDLINKAGE_GET_A"))), apply_to = any(function,type_alias,record,enum,variable,field))
#pragma cle begin XDLINKAGE_GET_A 
double fib(i) {
#pragma cle end XDLINKAGE_GET_A 
#pragma clang attribute pop
#pragma clang attribute push (__attribute__((annotate("ORANGE"))), apply_to = any(function,type_alias,record,enum,variable,field))
#pragma cle begin ORANGE
  static double p = 2.0;
  #pragma cle end ORANGE
#pragma clang attribute pop
  i++;
  if (i < 2) {
    return 1;
  }
  int one = 1;
  int two = 1;
  for(int j = 2; j < i; j++) {
    int temp = one;
    one = one + two;
    two = temp;
  }
  return one;
}



int main(int argc, char **argv) {
	return _slave_rpc_loop();
}