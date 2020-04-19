#pragma once
#include "pnt_data.h"
#include "observer.h"
#include <iostream>
#include <fstream> 

class Target : public Observer, public Subject
{
public:
  Distance  _d;
  Position _uav_pos;
  Track _track;
  int _frequency;
  int _cycle;
#ifdef PROC_SYNC
  int count = 0;
  ofstream os;
#endif
  
public:
  Target(int rate = 1) : _frequency(rate) {
    _cycle = static_cast<int> (((1.0 / _frequency) / (sleep_msec / 1000)));
#ifdef PROC_SYNC
    os.open("target.txt");
#endif
  };
  ~Target() {};

  Track getTracking() { return _track; }
  
  void update(Subject* s) override;
  void notify() override {
    for (auto e : _observers)
      e->update(this);
  }
  
  void print_track() {
#ifdef PROC_SYNC
    if (_track._pos._x == 0 &&
        _track._pos._y == 0 &&
        _track._pos._z == 0)
      return;

    os << ++count
       << "\t" << _track._pos._x
       << "\t" << _track._pos._y
       << "\t" << _track._pos._z
       << std::endl;
#else
    std::cout << "\t\t--- Target TRACK ---" << std::endl
	      << "\t\t x=" << _track._pos._x << std::endl
	      << "\t\t y=" << _track._pos._y << std::endl
	      << "\t\t z=" << _track._pos._z << std::endl << std::endl;
#endif
  }

protected:
  void setDistance(Distance const& d)    { _d = d; }
  void setUAVLocation(Position const& p) { _uav_pos = p; }

private:
  void targetLocation();
};

