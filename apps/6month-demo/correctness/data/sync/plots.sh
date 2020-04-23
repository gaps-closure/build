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
    local range="$3"
    
    local CMD="plot \"${INFILE}\" using 1:12 title \"Distance\""


    FILE="plots-${TYPE}"

    echo "set title '$title Errors, distances between original and partiioned'" > $FILE

    if [[ $range ]]; then
        echo "set yrange [$range]" >> $FILE
    fi

    if [[ $PNG ]]; then
        echo "set terminal png" >> $FILE
        echo "set output '${TYPE}-distance.png'" >> $FILE
    fi

    echo $CMD >> $FILE

    gnuplot -p -c $FILE
}

gen_plot_delay() {
    local TYPE=$1
    local sender=$2
    local receiver="$3"

    local combo=${TYPE}-${sender}-${receiver}
    local INFILE=./${combo}-loss.txt
    
    local CMD="plot \"${INFILE}\" using 1:7 title \"Delays\""


    FILE="plots-${combo}"

    if [[ $sender == "o" ]]; then
        title="Delay (us) - ${TYPE} - Orange to Green"
    else
        title="Delay (us) - ${TYPE} - Green to Orange"
    fi
    
    echo "set title '$title'" > $FILE

    if [[ $range ]]; then
        echo "set yrange [$range]" >> $FILE
    fi

    if [[ $PNG ]]; then
        echo "set terminal png" >> $FILE
        echo "set output '${combo}-delay.png'" >> $FILE
    fi

    echo $CMD >> $FILE

    gnuplot -p -c $FILE
}

gen_plot_loss() {
    local TYPE=$1
    local sender=$2
    local receiver="$3"

    local combo=${TYPE}-${sender}-${receiver}
    local INFILE=./${combo}-loss.txt
    
    local CMD="plot \"${INFILE}\" using 1:8 title \"Loss\" with linespoints"


    FILE="plots-${combo}"

    if [[ $sender == "o" ]]; then
        title="Loss - ${TYPE} - Orange to Green"
    else
        title="Loss - ${TYPE} - Green to Orange"
    fi
    
    echo "set title '$title'" > $FILE

    echo "set yrange [-1:2]" >> $FILE

    if [[ $PNG ]]; then
        echo "set terminal png" >> $FILE
        echo "set output '${combo}-loss.png'" >> $FILE
    fi

    echo $CMD >> $FILE

    gnuplot -p -c $FILE
}

handle_opts "$@"

gen_plots ownship "UAV Tracks ${CORR}"
gen_plots target "Target Tracks ${CORR}"
gen_plots_distance ownship "${CORR}" "-0.2:1.5"
gen_plots_distance target "${CORR}" "0:380"
#gen_plot_delay ownship g o
#gen_plot_delay ownship o g
#gen_plot_delay rfs o g

#gen_plot_loss ownship g o
#gen_plot_loss ownship o g
#gen_plot_loss rfs o g


