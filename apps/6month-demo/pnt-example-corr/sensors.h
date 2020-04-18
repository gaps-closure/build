#pragma once
#include "pnt_data.h"
#include "observer.h"
#include <chrono>

using namespace std::chrono;
using Clock = system_clock;
using msecs = milliseconds;
using Time = time_point<Clock, msecs>;

class Sensor : public Subject
{
public:
  Sensor() {
    _now = time_point_cast<msecs>(Clock::now());
  };
  virtual void read() = 0;
  
protected:
  Time _now;
};

class GpsSensor : public Sensor
{
  Position _p;
  Velocity _v; // only used for simulation

 public:
  GpsSensor(Position const& p, Velocity const& v) : _p(p), _v(v) { }
  Position getPosition() { return _p; }
#ifdef SCALED_SYNC
  Velocity getVelocity() { return _v; }
#endif
  Time getTimePoint() { return _now; }

  void read() override {
    auto now = time_point_cast<msecs>(Clock::now());
    simulate(_v, now); // we simulate position using fixed initial velocity
    _now = now;
  }
  void notify() override {
    for (auto e : _observers)
      e->update(this);
  }

 private:
  void simulate(Velocity const& v, Time const& now)
  {
    auto elapsed = duration_cast<msecs>(now - _now);
#ifdef VIRTUAL_CLOCK
    double delta = 10 / 1000.0;  // 100 Hz
#else
    double delta = elapsed.count() / 1000.0;
#endif
    _p._x += v._dx * delta;
    _p._y += v._dy * delta;
    _p._z += v._dz * delta;
    _v = v;
    notify();
  }

};

class RfSensor : public Sensor
{
  Distance _d;
  Velocity _v; // only used for simulation
#ifdef SCALED_SYNC
  bool _synced = false;
#endif
 public:
  RfSensor(Distance const& d, Velocity const& v) : _d(d), _v(v) { }
  Distance getDistance() { return _d; };
#ifdef SCALED_SYNC
  void setSynced(bool synced, GpsSensor *gps) {
    if (_synced)
        return;

    Velocity v = gps->getVelocity();
    double delta = gps->getPosition()._x / v._dx;
    _d._dx += v._dx * delta;
    _d._dy += v._dy * delta;
    _d._dz += v._dz * delta;

    _synced = synced;
  }
#endif
  void read() override {
    auto now = time_point_cast<msecs>(Clock::now());
    simulate(_v, now);
    _now = now;
  }
  void notify() override {
    for (auto e : _observers)
      e->update(this);
  }

 private:
  void simulate(Velocity const& v, Time const& now)
  {
#ifdef SCALED_SYNC
    if (!_synced)
      return;
#endif
    auto elapsed = duration_cast<msecs>(now - _now);
#ifdef VIRTUAL_CLOCK
    double delta = 100 / 1000.0;  // 10 Hz
#else
    double delta = elapsed.count() / 1000.0;
#endif
    _d._dx += v._dx * delta;
    _d._dy += v._dy * delta;
    _d._dz += v._dz * delta;

    _v = v;
    notify();
  }

};

