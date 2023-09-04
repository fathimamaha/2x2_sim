#!/bin/bash

#LCRC for DUNE specific dependancies
source /cvmfs/dune.opensciencegrid.org/products/dune/setup_dune.sh
#root comes with python2
setup root v6_12_06a -q e17:prof

# installs numpy and h5py for the user
python -m pip install h5py fire --user

#SETUP EDEPSIM for root
export GEN_DIR=/lcrc/project/LCRC_for_DUNE/users/fathima
export EDEPSIM=$GEN_DIR/edep-sim/install
export PATH=$EDEPSIM/bin:$PATH
export EDEPSIM_ROOT=$(dirname $(which edep-sim))/..
export LD_LIBRARY_PATH=$EDEPSIM/lib:$LD_LIBRARY_PATH

#CONVERT TO H5 VARIABLES
export ARCUBE_SPILL_NAME='MicroRun3.spill'
export ARCUBE_OUT_NAME='MicroRun3.convert2h5'
# export ARCUBE_INDEX='0'

for i in $(seq 78 99)
do  
    export ARCUBE_INDEX=$i;
    ./run_convert2h5.sh
done
