#!/bin/bash

run=MicroRun3.1_1E18_RHC
logdir=../../2x2_files/$run/logs

pushd ../run-convert2h5
# for i in $(seq 0 99)
# do  
#     export ARCUBE_INDEX=$i;
#     ./runs/MicroRun3.convert2h5.sh
# done
./runs/MicroRun3.convert2h5.sh
popd
