#include "ISRMshadow.h"
#include <heartbeat/HeartBeat.h>
int main(int argc, char **argv) {
	ISRM isrm(100);
	HeartBeat isrm_HB("ISRMshadow");
	isrm_HB.startup_Listener();
	isrm.run();
	Utils::sleep_forever();
	return 0;
}
