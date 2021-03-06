This file contains instructions for building and running the PSU program dependency generator, which is a key prerequisite for CLOSURE partioning and optimization. Currently this code is based on LLVM-5.0.  We will be porting this code to the latest LLVM code from the gaps-closure fork. The instructions below are for an Ubuntu system which has build-essentials and does not have other versions of LLVM/clang.

# Building on prescribed LLVM5 version
```
sudo apt install llvm-5.0
sudo apt install graphviz
sudo apt install clang-5.0
git clone https://bitbucket.org/psu_soslab/pdg-llvm5.0.git
cd pdg-llvm5.0
mkdir build
make
cat << EOF > helloworldmars.cpp
#include <iostream>

using namespace std;

#pragma cle def HIGH_1 \
{\
  "var": "foo", \
  "arr": [{"bar": "a2ltuae"}, {"baz": 42} \
}
  
int main()
{
  #pragma cle begin HIGH_1
  string str = "Hello World, Mars!";
  #pragma cle end HIGH_1
  cout << str << endl;
  return 0;
}
EOF

# XXX: Use CLE preprocessor to apply annotations to generate helloworldmars-mod.cpp

clang++-5.0 -S -emit-llvm helloworldmars-mod.cpp
llvm-as-5.0 helloworldmars-mod.ll 
opt-5.0 -load ./build/libpdg.so -dot-pdg helloworldmars-mod.bc
dotty pdgragh.main.dot
```

# Building on cuurent LLVM version on our fork
Folow the same instructions as above, but do not install llvm-5.0 or clang-5.0,
and make changes to two files as below before building. Also use clang++,
llvm-as and opt, instead of clang++-5.0, llvm-as-5.0, and opt-5.0.

In CMakeLists.txt, comment two lines at bottom, and add a new line as
follows.

```
37,39c37,38
< #target_compile_features(pdg PRIVATE cxx_range_for cxx_auto_type)
< #set_target_properties(pdg PROPERTIES COMPILE_FLAGS "-fno-rtti")
< set_target_properties(pdg PROPERTIES COMPILE_FLAGS "-fno-rtti -std=c++14")
---
> target_compile_features(pdg PRIVATE cxx_range_for cxx_auto_type)
> set_target_properties(pdg PROPERTIES COMPILE_FLAGS "-fno-rtti")
```

In FunctionWrapper.h, add a definition for DEBUG.

```
9,13d8
< #ifndef DEBUG
< #define DEBUG(X) X 
< #endif
< 
< 
```
