############################################################################
# Generate GEDL for application, autogenerate cross-domain program artifacts
############################################################################

IDIR=./divvied
EDIR=./divvied-working

ODIR=./partitioned/$(IPCMODE)
output_folder_create := $(shell mkdir -p $(ODIR))

AUTOGENDIR := $(ODIR)/autogen
autogen_folder_create := $(shell mkdir -p $(ODIR)/autogen)

ENCLAVES=
enclaves_set := $(foreach enclave,$(sort $(dir $(wildcard $(IDIR)//*/))), $(eval ENCLAVES+=$(notdir $(enclave:%/=%))))
enclave_folders_create := $(foreach enclave,$(ENCLAVES), $(shell mkdir -p $(ODIR)/$(enclave)))

CLANG_FLAGS=-emit-llvm -S -g -fno-builtin

JOIN=.make/join.sh

# Build arguments
LLVM_INCLUDE=$(LLVM10)/lib/clang/10.0.1/include

CFLAGS = -O2 -Wall -Wstrict-prototypes
LIB_OBJ= $(AUTOGENDIR)/float754.o $(AUTOGENDIR)/codec.o 
INCLUDES=-I$(LLVM_INCLUDE) -I$(CLOSURE_INCLUDES) -I../autogen 

# Different case from IPCMODE, same purpose, sigh!
IPC_MODE=$(IPCMODEGEN)

# Application configuration
INURI="ipc:///tmp/sock_sub"
OUTURI="ipc:///tmp/sock_pub"

CFLAGS += -I../../../amqlib -I../xdcc_echo -D__LEGACY_XDCOMMS__=1
CLANG_FLAGS += -I../../../amqlib -I../xdcc_echo -D__LEGACY_XDCOMMS__=1

############################################################################
# GEDL generation
############################################################################
gedl: $(ODIR)/$(PROG).gedl

$(ODIR)/$(PROG).gedl: $(ODIR)/gedl.ll
	cd $(ODIR) && $(OPT) -disable-output -load $(LIBGEDL) -accinfo-track -d 1 -prog $(PROG) -he ../heuristics < gedl.ll

gedlir: $(ODIR)/gedl.ll

$(ODIR)/gedl.ll: $(EDIR)/perencll.done
	$(foreach enclave,$(ENCLAVES), $(eval ENCLAVELL += $(EDIR)/$(enclave)/$(enclave).ll ))
	$(LLVMLINK) $(ENCLAVELL) -S -o $(ODIR)/gedl.ll > log/gedl.log

perencll: $(EDIR)/perencll.done

# create combined LL for each enclave, and do an opt pass to determine functions imported/exported by each enclave
$(EDIR)/perencll.done: $(EDIR)/compencs.done
	$(foreach enclave,$(ENCLAVES), $(LLVMLINK) $(shell find $(EDIR)/$(enclave) -name *.ll;) -S -o $(EDIR)/$(enclave)/$(enclave).ll;)
	$(foreach enclave,$(ENCLAVES), $(OPT) -disable-output -load $(LIBGEDL) -llvm-test -prefix $(ODIR)/$(enclave)/ < $(EDIR)/$(enclave)/$(enclave).ll > log/perecll_$(enclave).log;)
	touch $(EDIR)/perencll.done

compencs: $(EDIR)/compencs.done

# compile to LLVM IR
$(EDIR)/compencs.done: $(EDIR)/preproc.done
	$(foreach enclave,$(ENCLAVES), $(foreach p,$(shell find $(EDIR)/$(enclave) -name *.c;), $(CLANG) $(CLANG_FLAGS) $(INCLUDES) $p -o $(basename $p).ll >log/compencs_$(enclave).log;))
	touch $(EDIR)/compencs.done

preproc: $(EDIR)/preproc.done

# preprocess each C and H file, rename them back
$(EDIR)/preproc.done: $(EDIR)/cleancopy.done
	$(foreach enclave,$(ENCLAVES), $(eval PREPROCC += $(shell find $(EDIR)/$(enclave) -name *.c;)))
	$(foreach enclave,$(ENCLAVES), $(eval PREPROCH += $(shell find $(EDIR)/$(enclave) -name *.h;)))
	$(foreach p,$(PREPROCC), $(PREPROCESSOR) -s ${CLOSURE_SCHEMAS}/cle-schema.json -f $p -o $(dir $(p));)
	$(foreach p,$(PREPROCH), $(PREPROCESSOR) -s ${CLOSURE_SCHEMAS}/cle-schema.json -f $p -o $(dir $(p));)
	$(foreach p,$(PREPROCC), mv $(basename $p).mod.c $p;)
	$(foreach p,$(PREPROCH), mv $(basename $p).mod.h $p;)
	touch $(EDIR)/preproc.done

cleancopy: $(EDIR)/cleancopy.done

$(EDIR)/cleancopy.done:
	rm -rf $(EDIR) && cp -r $(IDIR) $(EDIR)
	touch $(EDIR)/cleancopy.done

############################################################################
# Autogeneration post GEDL generation
############################################################################
rpc: $(EDIR)/rpc.done

$(EDIR)/rpc.done: $(EDIR)/prerpc.done
	$(foreach enclave,$(ENCLAVES), $(eval ALL_RPCC += $(shell find $(ODIR)/$(enclave) -name *_rpc.c;)))
	$(foreach enclave,$(ENCLAVES), $(eval ALL_RPCH += $(shell find $(ODIR)/$(enclave) -name *_rpc.h;)))
	$(foreach p,$(ALL_RPCC), $(PREPROCESSOR) -s ${CLOSURE_SCHEMAS}/cle-schema.json -f $p -o $(dir $(p));)
	$(foreach p,$(ALL_RPCH), $(PREPROCESSOR) -s ${CLOSURE_SCHEMAS}/cle-schema.json -f $p -o $(dir $(p));)
	$(foreach p,$(ALL_RPCC), mv $(basename $p).mod.c $p;)
	$(foreach p,$(ALL_RPCH), mv $(basename $p).mod.h $p;) 
	$(foreach enclave,$(ENCLAVES), mkdir -p jsons/$(enclave);)
	$(foreach enclave,$(ENCLAVES), bash -f $(JOIN) $(ODIR)/$(enclave) jsons/$(enclave)/$(PROG).all.clemap.json;)
	touch $(EDIR)/rpc.done

# after generating RPC, run preprocessor on rpc files and rename; delete all LLs, but keep JSON
$(EDIR)/prerpc.done: rautogen $(AUTOGENDIR)/libcodecs.so $(AUTOGENDIR)/libcodecs.a $(ODIR)/$(PROG).all.clemap.json
	$(foreach enclave,$(ENCLAVES), $(eval ALL_IR += $(shell find $(EDIR)/$(enclave) -name *.ll;)))
	$(foreach p,$(ALL_IR), rm -f $p;)
	$(RPCGENERATOR) -o $(ODIR) -g $(ODIR)/$(PROG).gedl -i $(IPC_MODE) -a $(CLOSURE_LIBS) -n $(INURI) -t $(OUTURI) -e $(EDIR) -E $(ENCLAVES) -x xdconf.ini -m $(PROG) --cle $(ODIR)/$(PROG).all.clemap.json && \
	touch $(EDIR)/prerpc.done

rautogen: $(EDIR)/rautogen.done

$(ODIR)/$(PROG).all.clemap.json:          
	bash -f $(JOIN) $(EDIR) $(ODIR)/$(PROG).all.clemap.json

$(EDIR)/rautogen.done: idl
	cd $(AUTOGENDIR) && $(AUTOGEN) -i "$(PROG).idl" -g bw_v1 -d $(PROG)_bw.dfdl -e codec > $(PWD)/log/$(AUTOGEN)_bw.log \
	&& $(AUTOGEN) -i "$(PROG).idl" -g be_v1 -d $(PROG)_be.dfdl -e codec > $(PWD)/log/$(AUTOGEN)_be.log \
	&& echo $(PWD) && cd $(PWD) && touch $(EDIR)/rautogen.done

idl: $(EDIR)/idl.done

$(EDIR)/idl.done: gedl
	$(IDLGENERATOR) -s $(CLOSURE_SCHEMAS)/gedl-schema.json -g "$(ODIR)/$(PROG).gedl" -o "$(ODIR)/autogen/$(PROG).idl" -i $(IPC_MODE) \
	&& touch $(EDIR)/idl.done
	
slibs: $(AUTOGENDIR)/libcodecs.so 

libs: $(AUTOGENDIR)/libcodecs.a 

$(AUTOGENDIR)/libcodecs.a: $(LIB_OBJ)
	ar rcs $@ $^

$(AUTOGENDIR)/libcodecs.so: $(LIB_OBJ)
	$(CLANG) $(CFLAGS) -fPIC -shared -o $@ $<

clean: 
	rm -rf $(EDIR) $(ODIR)

.SECONDARY:
$(AUTOGENDIR)/%.o: $(AUTOGENDIR)/%.c
	$(CLANG) $(CFLAGS) -fPIC -c $< -o $@


