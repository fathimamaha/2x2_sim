#!/bin/bash

run=MicroRun3.1_1E18_RHC
logdir=../../2x2_files/$run/logs

pushd ../run-spill-build
for i in $(seq 0 99)
do  
    export ARCUBE_INDEX=$i;
    ./runs/MicroRun3.spill-build.sh
done
popd
