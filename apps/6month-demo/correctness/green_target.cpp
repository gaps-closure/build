#include "target.h"
#include "ownship.h"
#include "sensors.h"

#ifdef VIRTUAL_CLOCK
#include <mutex>

std::mutex m;

Subject *last_uav;
Subject *last_rfs;

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

                if (inqPos._x <= pos->_x)
                    last_uav = dequeue();

                if (inqPos._x >= pos->_x)
                    return true;
            }
            else {
                Distance *dis = (Distance *) s;
                RfSensor *inQ = dynamic_cast<RfSensor *>(head->subject);
                Distance inqPos = inQ->getDistance();

                if (inqPos._dx <= dis->_dx)
                    last_rfs = dequeue();

                if (inqPos._dx >= dis->_dx)
                    return true;
            }
        }
        return false;
    }
};

Queue uav_q;
Queue rfs_q;

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
        OwnShip *u = dynamic_cast<OwnShip *>(last_uav);
        setUAVLocation(u->getPosition());

        RfSensor *r = dynamic_cast<RfSensor *>(last_rfs);
        setDistance(r->getDistance());

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
