#!/bin/bash

#ON SWING MACHINES
module load anaconda3/2023-01-11

export ARCUBE_CONVERT2H5_NAME='MicroRun3.convert2h5'
export ARCUBE_OUT_NAME='MicroRun3.larnd'

pushd ../run-larnd-sim/larnd-sim
for i in $(seq 52 99)
do  
    export ARCUBE_INDEX=$i;
    ./run_larnd_sim.sh
done
popd
