CPPFLAGS=-std=c++11

ifdef vc
CPPFLAGS += -DVIRTUAL_CLOCK
CPPFLAGS += -DSCALED_SYNC
else
ifdef scale
CPPFLAGS += -DSCALED_SYNC
endif
endif

pnt: pnt_example.o ownship.o target.o
	$(CXX) -o $@ $^
clean:
	rm -f pnt *.o *.txt
