INCLUDE = -I ./include
INCLUDE += -I$(PINSTALL)/include/activemq-cpp-3.9.5 -I/usr/local/include/activemq-cpp-3.9.5
INCLUDE += -I/usr/include/apr-1.0
LDFLAGS += -L/usr/local/lib -L$(PINSTALL)/lib -lactivemq-cpp -lpthread
CXXFLAGS += -g $(INCLUDE) $(LDFLAGS) -fPIC -Wno-deprecated-declarations
CXX=g++

EXE_OBJ  = test.o
EXEC     = test

LIB_OBJ  = amqlib.o
LIB_LIB  = libamqlib.a
LIB_SLIB = libamqlib.so

default: all

all: $(EXEC)

lib: $(LIB_LIB) $(LIB_SLIB)

$(EXEC): $(EXE_OBJ) lib
	$(CXX) -o $@ $< $(CXXFLAGS) -L . -lamqlib

$(LIB_LIB): $(LIB_OBJ)
	ar -cvq $@ $^

$(LIB_SLIB): $(LIB_OBJ)
	$(CXX) -shared -o $@ $^ $(CXXFLAGS) 

.PHONY : force-rebuild

.c.o:
	gcc $< -o $@ -c

.cpp.o:
	$(CXX) $(CXXFLAGS) $< -o $@ -c

clean:
	-rm -f *.o *~ $(EXEC)

libclean: clean
	-rm -f $(LIB_LIB) $(LIB_SLIB) 
