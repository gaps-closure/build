MYLIB=-L$(CLOSURE_LIBS) -lxdcomms ../autogen/libcodecs.a -lzmq -lpthread

APPSRC=$(wildcard *.c)
APPOBJ=$(patsubst %.c, %.o, $(APPSRC)) 
APPEXE=${PROG}
APPLL=$(patsubst %.c, %.ll, $(APPSRC))

CFLAGS += -g -I/usr/include/python3.8
PYFLAGS = `python3-config --ldflags --libs`

CFLAGS += -I$(CLOSURE_INCLUDES) -I../autogen
CFLAGS += -D__LEGACY_XDCOMMS__=1
#CFLAGS += -D__ONEWAY_RPC__=1

$(APPEXE): $(APPOBJ)
	clang $(CFLAGS) -o $@ $^ $(MYLIB) $(PYFLAGS)

clean:
	rm -f $(APPEXE) $(APPOBJ) $(APPLL)

realclean:
	rm -f $(APPEXE) $(APPOBJ) $(APPLL)

.SECONDARY:

%.o: %.c
	clang -c $(CFLAGS) $< -o $@
