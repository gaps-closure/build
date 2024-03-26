# DIVINCLUDES=-I/usr/local/include,-I/usr/local/lib/clang/10.0.1/include,-I/usr/include,-I../../../amqlib,-I../xdcc_echo

# all:
#	$(DIV) -f topology.json -c ",-v,-x,c,$(DIVINCLUDES)" > log/9a_divide.log

DIVINCLUDES=""\
"--extra-arg=-I/usr/local/include "\
"--extra-arg=-I/usr/local/lib/clang/10.0.1/include "\
"--extra-arg=-I/usr/include "\
"--extra-arg=-I../../../amqlib "\
"--extra-arg=-I../xdcc_echo "

all:
	$(DIV_PLUGIN) $(DIVINCLUDES) topology.json > log/9a_divide.log