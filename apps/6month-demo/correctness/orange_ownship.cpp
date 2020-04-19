#include "ownship.h"
#include "sensors.h"

void OwnShip::update(Subject *s) {
  static int cnt = 0;
  GpsSensor *gps = dynamic_cast<GpsSensor *>(s);
  if (gps) {
#ifdef PROC_SYNC  
    _rfs->setSynced(true);
#endif
    setPosition(gps->getPosition());
  }
  if(_cycle != 0 && 0 == ++cnt % _cycle) {
    print_track();
    notify();
  }
}

