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

clean_up() {
    rm -f /tmp/sync*
    rm -f /tmp/taky.$COLR/*
    redis-cli flushdb
}

clean_up

set_up() {
    # pushd ~/gaps/taky
    # mate-terminal --tab --title "taky-$COLR" -e "taky -c taky-$COLR.conf"
    # popd
    mate-terminal --tab --title "sync-$COLR" -x ~/gaps/build/apps/sync/scripts/start_sync.sh -c $COLR
    echo "HM?"
    # pushd ~/gaps/build/apps/sync/partitioned/multithreaded/$COLR
    # export LD_LIBRARY_PATH=/home/ijones/gaps/build/hal/api
    # mate-terminal --tab --title "sync-$COLR" -e "./sync"
    # export LD_LIBRARY_PATH=
    # popd
    # mate-terminal --tab --title "debug-$COLR"

    # vboxmanage startvm "$COLR enclave"
}


shutdown (){
    # vboxmanage controlvm "$COLR enclave" poweroff
    rm /tmp/hal*
}

set_up
read -p "Press enter to shutdown"
shutdown