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


double calc_ewma(double a, double b) {
  const  double alpha = 0.25;
  static double c = 0.0;
  c = alpha * (a + b) + (1 - alpha) * c;
  return c;
}

double get_a() {
  static double a = 0.0;
  a += 1;
  return a;
}

double get_b() {
  static double b = 1.0;
  b += b;
  return b;
}

int ewma_main() {
  double x;
  double y;
  double ewma;
  for (int i=0; i < 10; i++) {
    x = get_a();
    y = get_b();
    ewma = calc_ewma(x,y);
    printf("%f\n", ewma);
  }
  return 0;
}
double fib() {
  static int i = 2;
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
int fib_main() {
  for (int i=0; i < 10; i++) {
    double x = fib();
    printf("%f\n", x);
  }
  return 0;
}


int main() {
  return fib_main(); 
}

