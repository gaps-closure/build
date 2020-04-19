#include "target.h"
#include "ownship.h"
#include "sensors.h"

#ifdef SCALED_SYNC
#include <mutex>

typedef struct _node {
   Subject *subject;
   struct _node *next;
} node_t;

class Queue
{
private:
    node_t *head;
    node_t *tail;
    int len;
public:
    Queue() {
        head = NULL;
        tail = NULL;
    }

    void enqueue(Subject *new_data) {
        node_t *new_node = (node_t *) malloc(sizeof(node_t));
        new_node->subject = new_data;
        new_node->next = NULL;

        if (tail == NULL)
            head = new_node;
        else
            tail->next = new_node;
        tail = new_node;

        len++;
    };

    Subject *dequeue() {
        if (head == NULL)
            return NULL;

        node_t *node = head;

        head = head->next;
        len--;
        if (head == NULL)
            tail = NULL;

        Subject *subject = node->subject;
        free(node);

        return subject;
    };

    int length() {
        return len;
    }
};

Queue uav_q;
Queue rfs_q;

static int seq = 0;
std::mutex m;
static bool expect_uav = true;

void Target::update(Subject *s)
{
    m.lock();

    OwnShip *uav = dynamic_cast<OwnShip *>(s);
    GpsSensor *gps = dynamic_cast<GpsSensor *>(s);
    RfSensor *rf = dynamic_cast<RfSensor *>(s);

    if (uav) {
        uav_q.enqueue(s);
    }
    else if (gps) {
        //update2(s);
        m.unlock();
        return;
    }
    else if (rf) {
        rfs_q.enqueue(s);
    }

    while (uav_q.length() > 0 && rfs_q.length() > 0) {
        Subject *uav = uav_q.dequeue();
        Subject *rfs = rfs_q.dequeue();

        update2(uav, rfs);
    }
    m.unlock();
}

void Target::update2(Subject *uavSub, Subject *rfsSub) {
    OwnShip *uav = dynamic_cast<OwnShip *>(uavSub);
    RfSensor *rf = dynamic_cast<RfSensor *>(rfsSub);

    static int uav_cnt = 0;
    static int rfs_cnt = 0;
    static bool uav_over = false;
    static bool rfs_over = false;
    Position uav_adj;
    Distance rfs_adj;

    double inc = (uav->getPosition()._x - _uav_pos._x) / 0.5;
    setUAVLocation(uav->getPosition());
    double rem = _cycle - uav_cnt % _cycle;
    uav_cnt += inc;
    if (inc >= rem)
        uav_over = true;
    //      printf("UAV %f %f %d %d\n", inc, rem, uav_cnt, uav_over);
    uav_adj._x = 0.5 * (inc - rem);
    uav_adj._y = 0.25 * (inc - rem);
    uav_adj._z = 0.12 * (inc - rem);


    inc = (_d._dx == 0) ? 1 : (rf->getDistance()._dx - _d._dx) / 3.5;
    setDistance(rf->getDistance());
    rem = _cycle - rfs_cnt % _cycle;
    rfs_cnt += inc;
    if (inc >= rem)
        rfs_over = true;
    //      printf("RFS %f %f %d %d\n", inc, rem, rfs_cnt, rfs_over);
    rfs_adj._dx = 3.5 * (inc - rem);
    rfs_adj._dy = 125 * (inc - rem);
    rfs_adj._dz = 1.8 * (inc - rem);

    if (uav_over == true && rfs_over == true) {
        _uav_pos._x -= uav_adj._x;
        _uav_pos._y -= uav_adj._y;
        _uav_pos._z -= uav_adj._z;
        _d._dx -= rfs_adj._dx;
        _d._dy -= rfs_adj._dy;
        _d._dz -= rfs_adj._dz;
//printf("================ %f %f\n", _uav_pos._x, _d._dx);
      targetLocation();
      print_track();
      notify();

      _uav_pos._x += uav_adj._x;
      _uav_pos._y += uav_adj._y;
      _uav_pos._z += uav_adj._z;
      _d._dx += rfs_adj._dx;
      _d._dy += rfs_adj._dy;
      _d._dz += rfs_adj._dz;
      uav_over = false;
      rfs_over = false;
    }
}

#else

void Target::update(Subject *s) {
  static int cnt = 0;
  bool tick = false;

  OwnShip *uav = dynamic_cast<OwnShip *>(s);
  GpsSensor *gps = dynamic_cast<GpsSensor *>(s);
  RfSensor *rf = dynamic_cast<RfSensor *>(s);
  if (uav) {
    setUAVLocation(uav->getPosition());
  } else if (gps) {
    tick = true; // yeah.. hackish
  } else if (rf) {
    setDistance(rf->getDistance());
  }

  if (tick && _cycle != 0 && 0 == ++cnt % _cycle) {
    targetLocation();
    print_track();
    notify();
  }
}
#endif

void Target::targetLocation() {
  _track._pos._x = _uav_pos._x + _d._dx;
  _track._pos._y = _uav_pos._y + _d._dy;
  _track._pos._z = _uav_pos._z + _d._dz;
}
