#!/bin/bash

run=MicroRun3.1_1E18_RHC
logdir=../../2x2_files/$run/logs

pushd ../run-edep-sim
for i in $(seq 63 63)
do  
    export ARCUBE_INDEX=$i;
    ./runs/MicroRun3.nu.edep-sim.sh
done
popd
