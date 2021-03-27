#ifndef _Purple_RPC_
#define _Purple_RPC_
#include "xdcomms.h"
#include "codec.h"

# define APP_BASE 0
# define MUX_NEXTRPC APP_BASE + 1
# define SEC_NEXTRPC APP_BASE + 1
# define MUX_OKAY APP_BASE + 2
# define SEC_OKAY APP_BASE + 2
# define MUX_REQUEST_FIB APP_BASE + 1
# define SEC_REQUEST_FIB APP_BASE + 1
# define MUX_RESPONSE_FIB APP_BASE + 2
# define SEC_RESPONSE_FIB APP_BASE + 2

#define INURI  "ipc:///tmp/example2subpurple"
#define OUTURI "ipc:///tmp/example2pubpurple"
#pragma cle def TAG_RESPONSE_FIB {"level":"purple",\
	"cdf": [\
		{"remotelevel":"purple", \
			"direction": "egress", \
			"guarddirective": { "operation": "allow", \
						"gapstag": [2,2,4] }} \
	] }
#pragma cle def TAG_REQUEST_FIB {"level":"purple",\
	"cdf": [\
		{"remotelevel":"orange", \
			"direction": "egress", \
			"guarddirective": { "operation": "allow", \
						"gapstag": [1,1,3] }} \
	] }
#pragma cle def TAG_OKAY {"level":"purple",\
	"cdf": [\
		{"remotelevel":"purple", \
			"direction": "egress", \
			"guarddirective": { "operation": "allow", \
						"gapstag": [2,2,2] }} \
	] }
#pragma cle def TAG_NEXTRPC {"level":"purple",\
	"cdf": [\
		{"remotelevel":"orange", \
			"direction": "egress", \
			"guarddirective": { "operation": "allow", \
						"gapstag": [1,1,1] }} \
	] }
extern void _master_rpc_init();
extern double _rpc_fib(int i);


#endif /* _PURPLE_RPC_ */