#!/bin/bash

usage_exit() {
  [[ -n "$1" ]] && echo $1
  echo "Usage: $0 [ -vsh ] \\"
  echo "-p  Output to PNG"
  echo "-l <Correction Applied>"
  echo "-h  Help"
  exit 1
}

handle_opts() {
  local OPTIND
  while getopts "l:ph" options; do
    case "${options}" in
      p) PNG=1                ;;
      l) CORR="(${OPTARG})"   ;;
      h) usage_exit "Help"    ;;
      :) usage_exit "Error: -${OPTARG} requires an argument." ;;
    esac
  done
  
  shift $((OPTIND -1))
  components=($@)
}

gen_plots() {
    local TYPE=$1
    local INFILE=./${TYPE}.distances
    local title=$2
    
    local CMD="plot "

    COORDS=(X Y Z)
    COORDS_PART=(X-part Y-part Z-part)

    for col in {2..4}
    do
        let i=$col-2;
        CMD+="\"${INFILE}\" using 2:$col title \"${COORDS[${i}]}\", "
    done

    for col in {6..8}
    do
        let i=$col-6;
        CMD+="\"${INFILE}\" using 6:$col title \"${COORDS_PART[${i}]}\", "
    done

    FILE="plots-${TYPE}"

    echo "set title '$title'" > $FILE

    if [[ $PNG ]]; then
        echo "set terminal png" >> $FILE
        echo "set output '${TYPE}.png'" >> $FILE
    fi

    echo $CMD >> $FILE

    gnuplot -p -c $FILE
}

gen_plots_distance() {
    local TYPE=$1
    local INFILE=./${TYPE}.distances
    local title=$2
    
    local CMD="plot \"${INFILE}\" using 1:12 title \"Distance\""


    FILE="plots-${TYPE}"

    echo "set title '$title Errors, distances between original and partiioned'" > $FILE

    if [[ $PNG ]]; then
        echo "set terminal png" >> $FILE
        echo "set output '${TYPE}-distance.png'" >> $FILE
    fi

    echo $CMD >> $FILE

    gnuplot -p -c $FILE
}

handle_opts "$@"

gen_plots ownship "UAV Tracks ${CORR}"
gen_plots target "Target Tracks ${CORR}"
gen_plots_distance ownship "UAV Tracks ${CORR}"
gen_plots_distance target "Target ${CORR}"

