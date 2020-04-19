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

    bool reached(bool uav, void *s) {
        while (head != NULL) {
            if (uav) {
                Position *pos = (Position *) s;
                OwnShip *inQ = dynamic_cast<OwnShip *>(head->subject);
                Position inqPos = inQ->getPosition();

                if (inqPos._x < pos->_x)
                    dequeue();
                else
                    return true;
            }
            else {
                Distance *dis = (Distance *) s;
                RfSensor *inQ = dynamic_cast<RfSensor *>(head->subject);
                Distance inqPos = inQ->getDistance();
                if (inqPos._dx < dis->_dx)
                    dequeue();
                else
                    return true;
            }
        }
        return false;
    }
};

Queue uav_q;
Queue rfs_q;

std::mutex m;

void Target::update(Subject *s)
{
    m.lock();

    static Position exp_uav(4.5, 2.25, 1.08);
    static Distance exp_rfs(1093.5, 8362.5, 9016.2);

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

    while (uav_q.reached(true, &exp_uav) && rfs_q.reached(false, &exp_rfs)) {
        setUAVLocation(exp_uav);
        setDistance(exp_rfs);
        targetLocation();
        print_track();
        notify();

        exp_uav._x += _cycle * 0.5;
        exp_uav._y += _cycle * 0.25;
        exp_uav._z += _cycle * 0.12;

        exp_rfs._dx += _cycle * 3.5;
        exp_rfs._dy += _cycle * 62.5;
        exp_rfs._dz += _cycle * 1.8;
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

    static Position exp_uav(5, 2.5, 1.2);
    static Distance exp_rfs(35, 1250, 18);

    double inc = (uav->getPosition()._x - _uav_pos._x) / 0.5;
    setUAVLocation(uav->getPosition());
    double rem = _cycle - uav_cnt % _cycle;
    uav_cnt += inc;
    if (inc >= rem)
        uav_over = true;
    exp_uav._x = 0.5 * (inc - rem);
    exp_uav._y = 0.25 * (inc - rem);
    exp_uav._z = 0.12 * (inc - rem);
    printf("UAV %.2f %.2f %d %d %.2f\n", inc, rem, uav_cnt, uav_over, (inc - rem));

    inc = (_d._dx == 0) ? 1 : (rf->getDistance()._dx - _d._dx) / 3.5;
    setDistance(rf->getDistance());
    rem = _cycle - rfs_cnt % _cycle;
    rfs_cnt += inc;
    if (inc >= rem)
        rfs_over = true;
    exp_rfs._dx = 3.5 * (inc - rem);
    exp_rfs._dy = 125 * (inc - rem);
    exp_rfs._dz = 1.8 * (inc - rem);
    printf("RFS %.2f %.2f %d %d %.2f\n", inc, rem, rfs_cnt, rfs_over, (inc - rem));

    if (uav_over == true && rfs_over == true) {
        _uav_pos._x -= exp_uav._x;
        _uav_pos._y -= exp_uav._y;
        _uav_pos._z -= exp_uav._z;
        _d._dx -= exp_rfs._dx;
        _d._dy -= exp_rfs._dy;
        _d._dz -= exp_rfs._dz;
printf("================ %.2f %.2f %.2f %.2f %.2f %.2f\n", exp_uav._x, exp_uav._y, exp_uav._z, exp_rfs._dx, exp_rfs._dy, exp_rfs._dz);
      targetLocation();
      print_track();
      notify();

      _uav_pos._x += exp_uav._x;
      _uav_pos._y += exp_uav._y;
      _uav_pos._z += exp_uav._z;
      _d._dx += exp_rfs._dx;
      _d._dy += exp_rfs._dy;
      _d._dz += exp_rfs._dz;
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
