#!/bin/bash
COLR=
ENVR=

usage_exit() {
  [[ -n "$1" ]] && echo $1
  echo "Usage: $0 [ -h ] [ -c COLR ] [ -e ENVR ]"
  echo "-h                  Help"
  echo "-c COLR             Enclave color - {red, yellow}"
  echo "-e ENVR             Where the demo is running - {network, xarbitor}"
  exit 1
}

handle_opts() {
    local OPTIND
    while getopts "c:e:h" options; do
	case "${options}" in
	    c) COLR=${OPTARG}               ;;
	    e) ENVR=${OPTARG}               ;;
        h) usage_exit                   ;;
	    :) usage_exit "Error: -${OPTARG} requires argument." ;;
	    *) usage_exit
	esac
    done
    shift "$((OPTIND-1))"
    
    if [ "x$COLR" == "x" ] || [ "x$ENVR" == "x" ]; then
        echo "Missing -c or -e" >&2
	    usage_exit
    fi

    echo "sucessful"
}
handle_opts "$@"


case $ENVR in
    network)
    ;;
    xarbitor)
    ;;
    *)
    echo "Environment must be network or xarbitor"
    exit 1
    ;;
esac

case $COLR in
    red)
	;;
    yellow)
	;;
    *)
	echo "Environment must be red or yellow"
	exit 1
	;;
esac

clean_up() {
    rm -f /tmp/sync*
    rm -f /tmp/hal*
    rm -f /tmp/taky.$COLR/*
    redis-cli flushdb
}

set_up() {
    case $ENVR in
        network)
            mate-terminal --tab --title "taky-$COLR" -x ~/gaps/build/apps/sync/.demo/start_taky.sh -c $COLR
            mate-terminal --tab --title "hal-$COLR" -x ~/gaps/build/apps/sync/.demo/start_hal.sh -c $COLR
            mate-terminal --tab --title "sync-$COLR" -x ~/gaps/build/apps/sync/.demo/start_sync.sh -c $COLR
            mate-terminal --tab --title "debug-$COLR"

            vboxmanage startvm "$COLR enclave"
        ;;
        xarbitor)
            mate-terminal --tab --title "taky-$COLR" -x ~/taky/run_taky.sh
            mate-terminal --tab --title "recv-$COLR" -x ~/sync/run_recv_$COLR.sh
            mate-terminal --tab --title "sync-$COLR" -x ~/sync/run_sync_$COLR.sh
            mate-terminal --tab --title "debug-$COLR"
        ;;
    esac
}

shutdown (){

    if [ "$ENVR" == "network" ]; then
    vboxmanage controlvm "$COLR enclave" poweroff
    fi

    sudo pkill -f taky
    sudo pkill -f sync
    sudo pkill -f hal 
    redis-cli flushdb
}

clean_up
set_up
read -p "Press enter to shutdown"
shutdown

echo "DEMO EXIT"