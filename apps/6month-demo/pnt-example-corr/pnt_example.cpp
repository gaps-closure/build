// pnt_example.cpp : Defines the entry point for the console application.
//

#include <iostream>
#ifdef _WIN32
# include <Windows.h>
#else
# include <unistd.h>
#endif
#include "pnt_data.h"
#include "sensors.h"
#include "ownship.h"
#include "target.h"

#ifdef SCALED_SYNC
int sample_count = 1000000;

void usage()
{
    printf("Usage: <this-program> \n\
\t -h     \t help\n\
\t -c     \t sample count\n");
    exit(1);
}

void parse(int argc, char **argv)
{
    char enc[64] = { '\0' };
    char flow_loaded = 0;
    int c;

    while ((c = getopt(argc, argv, "hc:")) != -1) {
        switch (c) {
        case 'c':
            sample_count = atoi(optarg);
            break;
        case 'h':
            usage();
            break;
        default:
            usage();
        }
    }
}

int main(int argc, char **argv)
{
    parse(argc, argv);

#else
int main()
{
#endif
  Position p(.0, .0, .0); // initial position
  Distance d(1062, 7800, 9000); // initial target distance

  Velocity v(50, 25, 12);
  Velocity vtgt(35, 625, 18);
  
  GpsSensor* gps = new GpsSensor(p, v);
  RfSensor* rfs = new RfSensor(d, vtgt);
  
  OwnShip* uav = new OwnShip(100); // updates at 100 Hz frequency
  Target* tgt = new Target (10); // updates at 10 Hz frequency

  // setup the dataflow relationships
  gps->attach(uav);
  gps->attach(tgt);
  uav->attach(tgt);
  rfs->attach(tgt);

#ifdef SCALED_SYNC  
  uav->registerSensor(rfs);
#endif
  
  while (true)
    {
      // here we simulate sensor data streams
      gps->read();
      rfs->read();
      
#ifdef _WIN32	  
      Sleep(sleep_msec); // 100 Hz
#else
      usleep(sleep_msec * 1000);
#endif
    }
  return 0;
}

