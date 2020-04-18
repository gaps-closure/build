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
        if (expect_uav) {
            update2(s);
            expect_uav = false;
        }
        else {
            uav_q.enqueue(s);
        }
    }
    else if (gps) {
        update2(s);
    }
    else if (rf) {
        if (!expect_uav) {
            update2(s);
            expect_uav = true;
        }
        else {
            rfs_q.enqueue(s);
        }
    }
    m.unlock();
}

void Target::update2(Subject *s) {

#else

void Target::update(Subject *s) {

#endif
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

void Target::targetLocation() {
  _track._pos._x = _uav_pos._x + _d._dx;
  _track._pos._y = _uav_pos._y + _d._dy;
  _track._pos._z = _uav_pos._z + _d._dz;
}
