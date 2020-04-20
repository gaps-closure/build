#!/bin/bash

DIR=("logging" "sync" "vc")
CORR=("no correction" "proc sync" "proc sync + virtual clock")

for c in {0..2}
do
    cp data/${DIR[$c]}/*.distances .
    ./plots.sh -l "${CORR[$c]}" -p
    mv *.png data/${DIR[$c]}
done

