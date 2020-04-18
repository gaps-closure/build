#pragma once
#include "pnt_data.h"
#include "observer.h"
#include "sensors.h"
#include <iostream>
#include <fstream>

class OwnShip: public Observer, public Subject
{
  Track _track;
  int _frequency;
  int _cycle;
#ifdef SCALED_SYNC
  int count = 0;
  ofstream os;
  RfSensor *_rfs;
#endif
  
public:
  OwnShip(int rate = 1) : _frequency(rate) {
    _cycle = static_cast<int> (((1.0 / _frequency) / (sleep_msec / 1000)));
#ifdef SCALED_SYNC
    os.open("ownship-part.csv");
#endif
  };
  ~OwnShip() {};

  Position getPosition() { return _track._pos; }
  Track getTracking() { return _track; }

  virtual void update(Subject *s) override;
  
  void notify() override {
    for (auto e : _observers)
      e->update(this);
  }

  void print_track()
  {
#ifdef SCALED_SYNC
    os << ++count  
       << "," << _track._pos._x 
       << ", " << _track._pos._y 
       << ", " << _track._pos._z << "," << std::endl;
#else
    std::cout << "---UAV TRACK ---" << std::endl
	      << " x=" << _track._pos._x << std::endl
	      << " y=" << _track._pos._y << std::endl
	      << " z=" << _track._pos._z << std::endl << std::endl;
#endif
  }
#ifdef SCALED_SYNC
  void registerSensor(RfSensor *rfs) { _rfs = rfs; }
#endif
  
protected:
  void setPosition(Position const& p) { _track._pos = p; }
  void setVelocity(Velocity const& v) { _track._v = v; }
  
};
