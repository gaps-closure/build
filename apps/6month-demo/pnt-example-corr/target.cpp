#include "target.h"
#include "ownship.h"
#include "sensors.h"

void Target::update(Subject *s) {
  static int uav_cnt = 0;
  static int rfs_cnt = 0;
  bool tick = false;
  
  OwnShip *uav = dynamic_cast<OwnShip *>(s);
  GpsSensor *gps = dynamic_cast<GpsSensor *>(s);
  RfSensor *rf = dynamic_cast<RfSensor *>(s);
  if (uav) {
    setUAVLocation(uav->getPosition());
    uav_cnt++;
  } else if (gps) {
    tick = true; // yeah.. hackish
    return;
  } else if (rf) {
    setDistance(rf->getDistance());
    rfs_cnt++;
  }

  if (uav_cnt % _cycle == 0 && rfs_cnt % _cycle == 0) {
    targetLocation();
    print_track();
    notify();
  }
}

void Target::targetLocation() {
  _track._pos._x = _uav_pos._x + _d._dx;
  _track._pos._y = _uav_pos._y + _d._dy;
  _track._pos._z = _uav_pos._z + _d._dz;
}
