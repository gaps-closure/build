#!/bin/bash
COLR=

usage_exit() {
  [[ -n "$1" ]] && echo $1
  echo "Usage: $0 [ -h ] [ -c COLR]"
  echo "-h          Help"
  echo "-c COLR     Enclave color (e.g, red, yellow)"
  exit 1
}

handle_opts() {
    local OPTIND
    while getopts "c:" options; do
	case "${options}" in
	    c) COLR=${OPTARG}      ;;
	    h) usage_exit          ;;
	    :) usage_exit "Error: -${OPTARG} requires argument." ;;
	    *) usage_exit
	esac
    done
    shift "$((OPTIND-1))"

    if [[ "x$COLR" == "x" ]]; then
	usage_exit
    fi
}

handle_opts "$@"

pushd ~/gaps/build/hal/test/sync
../../daemon/hal -l 0 ./sync_$COLR.cfg |& tee /tmp/hal-$COLR.log
popd