CPPFLAGS=-std=c++11

ifdef vc
CPPFLAGS += -DVIRTUAL_CLOCK
CPPFLAGS += -DPROC_SYNC
else
ifdef sync
CPPFLAGS += -DPROC_SYNC
endif
endif

pnt: pnt_example.o ownship.o target.o
	$(CXX) -o $@ $^
clean:
	rm -f pnt *.o *.txt
