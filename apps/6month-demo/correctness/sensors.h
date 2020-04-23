#pragma once
#include "pnt_data.h"
#include "observer.h"

#include <thread>

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

// CHANGE: add
void setPosition(Position const& p) { _p = p; }
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
#ifdef PROC_SYNC
  bool _synced = false;
#endif
 public:
  RfSensor(Distance const& d, Velocity const& v) : _d(d), _v(v) { }
  Distance getDistance() { return _d; };
// CHANGE: add
void setDistance(Distance const& d) { _d = d; }

#ifdef PROC_SYNC
  void setSynced(bool synced) {
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
#ifdef PROC_SYNC
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

class GpsSensorShadow : public GpsSensor
{
private:
    std::thread thread_;
    void receive();

public:
    GpsSensorShadow(Position const& p, Velocity const& v) :  GpsSensor(p, v) {
      thread_ = std::thread(&GpsSensorShadow::receive, this);
    }
    ~GpsSensorShadow() { thread_.join(); }

    void read() override {
    }
};

class RfSensorShadow : public RfSensor
{
private:
    std::thread thread_;
    void receive();

public:
    RfSensorShadow(Distance const& d, Velocity const& v) :  RfSensor(d, v) {
      thread_ = std::thread(&RfSensorShadow::receive, this);
    }
    ~RfSensorShadow() { thread_.join(); }

    void read() override {
    }
};
