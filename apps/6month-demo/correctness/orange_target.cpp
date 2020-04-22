#include "target.h"
#include "ownship.h"
#include "sensors.h"

#include "hal_xdcomms.h"
#include "hal_gma.h"

void Target::update(Subject *s) {
}

void update2(Subject *uav, Subject* rfs) {
}

void Target::targetLocation() {
}

void TargetShadow::update(Subject *s) {
  OwnShip *uav = dynamic_cast<OwnShip *>(s);
  RfSensor *rf = dynamic_cast<RfSensor *>(s);
#ifdef LOGGING
  static int count_uav = 0, count_rfs = 0;
  static ofstream os_uav("ownship-o-snd.txt"), os_rfs("rfs-o-snd.txt");
#endif

  if (uav) {
    Position position  = uav->getPosition();
    position_datatype pos;
    pos.x = position._x;
    pos.y = position._y;
    pos.z = position._z;
    pos.trailer.seq = seq;
    pos.trailer.rqr = rqr;
    pos.trailer.oid = oid;
    pos.trailer.mid = mid;
    pos.trailer.crc = crc;

    #pragma cle begin TAG_2_2_1
    gaps_tag  t_tag;
    #pragma cle end TAG_2_2_1
    uint32_t  t_mux = 2, t_sec = 2, type = DATA_TYP_POSITION;

    tag_write(&t_tag, t_mux, t_sec, type);

    if (send_pos_socket == NULL)
        send_pos_socket = xdc_pub_socket();
    xdc_asyn_send(send_pos_socket, &pos, &t_tag);

#ifdef LOGGING
    os_uav << ++count_uav
           << "\t" << position._x
           << "\t" << position._y
           << "\t" << position._z
           << std::endl;
#endif
  }
  else if (rf) {
    Distance distance  = rf->getDistance();
    distance_datatype dis;
    dis.x = distance._dx;
    dis.y = distance._dy;
    dis.z = distance._dz;
    dis.trailer.seq = seq;
    dis.trailer.rqr = rqr;
    dis.trailer.oid = oid;
    dis.trailer.mid = mid;
    dis.trailer.crc = crc;

//printf("send TGT %f %f %f\n", dis.x, dis.y, dis.z);
    #pragma cle begin TAG_2_2_2
    gaps_tag  t_tag;
    #pragma cle end TAG_2_2_2
    uint32_t  t_mux = 2, t_sec = 2, type = DATA_TYP_DISTANCE;

    tag_write(&t_tag, t_mux, t_sec, type);

    if (send_dis_socket == NULL)
        send_dis_socket = xdc_pub_socket();
    xdc_asyn_send(send_dis_socket, &dis, &t_tag);
#ifdef LOGGING
    os_rfs << ++count_rfs
           << "\t" << distance._dx
           << "\t" << distance._dy
           << "\t" << distance._dz
           << std::endl;
#endif
  }
}
