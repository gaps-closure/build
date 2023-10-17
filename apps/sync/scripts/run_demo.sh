#!/bin/bash
COLR=
ENVR=

usage_exit() {
  [[ -n "$1" ]] && echo $1
  echo "Usage: $0 [ -h ] [ -c COLR ] [ -e ENVR ]"
  echo "-h                  Help"
  echo "-c COLR             Enclave color - {red, yellow}"
  echo "-e ENVR             Where the demo is running - {remote, xarbitor}"
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
export DISPLAY=$DISPLAY

case $ENVR in
    remote)

	;;
    xarbitor)
	;;
    *)
	echo "Environment must be remote or xarbitor"
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
    rm -f /tmp/taky*
    redis-cli flushdb
}

set_up() {
    pushd ~/gaps/taky
    mate-terminal --tab --title "taky-$COLR" -e "taky -c taky-liono-$COLR.conf" &
    popd
    echo "PRINT COLORS"
    pushd ~/gaps/build/hal/test/sync
    mate-terminal --tab --title "hal-$COLR" -e "../../daemon/hal -l 0 ./sync_$COLR.cfg" &
    popd
    pushd ~/gaps/build/apps/sync/partitioned/multithreaded/$COLR
    mate-terminal --tab --title "sync-$COLR" -e "LD_LIBRARY_PATH=/home/ijones/gaps/build/hal/api ./sync" &
    popd
    mate-terminal --tab --title "debug-$COLR" &

    vboxmanage startvm "$COLR enclave"
}

# start_demo() {

# }

shutdown (){
    vboxmanage controlvm "$COLR enclave" poweroff
}

clean_up
set_up
read -p "Press enter to shutdown"
# start_demo
# read -p "Proceed to ATAK to send message"
shutdown
# # stop_demo

# # start_demo

echo "DONEZO"