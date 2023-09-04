#!/bin/bash

#ON BEBOP MACHINES
module load anaconda3/2023.03


export ARCUBE_IN_NAME='MicroRun3.larnd'
export ARCUBE_OUT_NAME='MicroRun3.flow'

pushd ../run-ndlar-flow
source flow.venv/bin/activate
for i in $(seq 0 99)
do  
    export ARCUBE_INDEX=$i;
    ./run_ndlar_flow.sh
done
popd
