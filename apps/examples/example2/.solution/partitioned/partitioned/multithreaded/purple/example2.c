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

int fib_main() {
#pragma clang attribute push (__attribute__((annotate("PURPLE"))), apply_to = any(function,type_alias,record,enum,variable,field))
  #pragma cle begin PURPLE
  double x;
  #pragma cle end PURPLE
#pragma clang attribute pop
  for (int i= 0; i < 20; i++) {
     x = _rpc_fib(i);
    printf("%f\n", x);
  }
  for (int i= 0; i < 30; i++) {
     x = _rpc_fib(i);
    printf("%f\n", x);
  }

  return 0;
}


int main() {
	_master_rpc_init();
  return fib_main(); 
}

