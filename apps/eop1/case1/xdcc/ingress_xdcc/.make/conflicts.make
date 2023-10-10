IDIR=./annotated
EDIR=./annotated-working
CLANG_ARGS += -I$(realpath ../xdcc_echo),-I$(realpath ../../../amqlib),-I/usr/local/include/activemq-cpp-3.9.5
CONSTRAINTS=$(CLOSURE_PYTHON)/conflict_analyzer/constraints

assignments: topology 

topology: topology.json

topology.json: $(EDIR)
	conflict_analyzer \
	--pdg-lib $(CLOSURE_LIBS)/libpdg.so \
	--output topology.json \
	--artifact artifact.json \
	--temp $(EDIR) \
	--source-path $(realpath .)/refactored \
	--clang-args="$(CLANG_ARGS)" \
	--dump-ptg=`which dump-ptg` \
	annotated/$(PROG).c 

$(EDIR):
	mkdir -p $(EDIR)