CLOSURE_DIR=/opt/closure
ODIR=./partitioned/$(IPCMODE)
EMU_DIR=$(CLOSURE_DIR)/emu
CFG_DIR=$(EMU_DIR)/config/$(PROG)

autogen_dir := $(ODIR)/autogen
LIB_OBJ= $(autogen_dir)/float754.o $(autogen_dir)/codec.o 

INCLUDES=-I $(CLOSURE_INCLUDES) -I ../autogen 
LDLIBS=-L $(CLOSURE_LIBS)
LIBS=../autogen/libcodecs.a -lpthread

ifeq ($(HWMODE), ilip)
	DEVFILE := $(CLOSURE_DEVICES)/devices_eop_ilip_v3.json
else ifeq ($(HWMODE), emu)
	DEVFILE := $(CLOSURE_DEVICES)/devices_socat.json
else ifeq ($(HWMODE), mind)
	DEVFILE := $(CLOSURE_DEVICES)/devices_eop_mind.json
endif

pkg:
	tar cf ${PROG}-green-enclave-gw-O.tar -C partitioned/$(IPCMODE)/green/ . -C $(CLOSURE_LIBS) libxdcomms.so 
	tar cf ${PROG}-orange-enclave-gw-G.tar -C partitioned/$(IPCMODE)/orange/ . -C $(CLOSURE_LIBS) libxdcomms.so
	rm -rf $(EMU_DIR)/.apps
	mkdir -p $(EMU_DIR)/.apps
	mv *.tar $(EMU_DIR)/.apps/
	$(HALGEN) -o $(CFG_DIR) -x $(ODIR)/xdconf.ini -d $(DEVFILE) -p $(PROG)_hal
