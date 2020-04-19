#!/bin/bash

usage_exit() {
  [[ -n "$1" ]] && echo $1
  echo "Usage: $0 [ -vsh ] \\"
  echo "-o  Ownship"
  echo "-t  Target"
  echo "-x  Ownship Distances"
  echo "-y  Target Distances"
  echo "-p  Output to PNG"
  echo "-l <TITLE>"
  echo "-h  Help"
  exit 1
}

handle_opts() {
  local OPTIND
  while getopts "l:optxyh" options; do
    case "${options}" in
      o) OWNSHIP=1            ;;
      t) TARGET=1             ;;
      x) OWNSHIP_DISTANCE=1   ;;
      y) TARGET_DISTANCE=1    ;;
      p) PNG=1                ;;
      l) TITLE=${OPTARG}      ;;
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


    if [[ $PNG ]]; then
        echo "set terminal png" > $FILE
        echo "set output '${TYPE}.png'" >> $FILE
    else
        echo > $FILE
    fi

    if [[ $TITLE ]]; then
        echo "set title '$TITLE'" >> $FILE
    elif [[ $OWNSHIP ]]; then
        echo "set title 'UAV Tracks'" >> $FILE
    elif [[ $TARGET ]]; then
        echo "set title 'Target Tracks'" >> $FILE
    fi

    echo $CMD >> $FILE
}

gen_plots_distance() {
    local TYPE=$1
    local INFILE=./${TYPE}.distances

    local CMD="plot \"${INFILE}\" using 1:12 title \"Distance\""


    FILE="plots-${TYPE}"


    if [[ $PNG ]]; then
        echo "set terminal png" > $FILE
        echo "set output '${TYPE}.png'" >> $FILE
    else
        echo > $FILE
    fi

    echo "set title 'Errors $TITLE (Distances between $TYPE positions of the Original and Partiioned Programs)'" >> $FILE

    echo $CMD >> $FILE
}

handle_opts "$@"

if [[ $OWNSHIP ]]; then
    gen_plots ownship
elif [[ $TARGET ]]; then
    gen_plots target
elif [[ $OWNSHIP_DISTANCE ]]; then
    gen_plots_distance ownship
elif [[ $TARGET_DISTANCE ]]; then
    gen_plots_distance target
fi
gnuplot -p -c $FILE

