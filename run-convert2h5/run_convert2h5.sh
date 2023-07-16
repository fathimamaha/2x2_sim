#!/bin/bash

#LCRC for DUNE specific dependancies
source /cvmfs/dune.opensciencegrid.org/products/dune/setup_dune.sh
#root comes with python2
setup root v6_12_06a -q e17:prof

#installs numpy and h5py for the user
python -m pip install h5py fire --user

#SETUP EDEPSIM for root
export GEN_DIR=/lcrc/project/LCRC_for_DUNE/users/fathima
export EDEPSIM=$GEN_DIR/edep-sim/install
export PATH=$EDEPSIM/bin:$PATH
export EDEPSIM_ROOT=$(dirname $(which edep-sim))/..
export LD_LIBRARY_PATH=$EDEPSIM/lib:$LD_LIBRARY_PATH

#CONVERT TO H5 VARIABLES
export ARCUBE_SPILL_NAME='test_MiniRun3.spill'
export ARCUBE_OUT_NAME='test_MiniRun3.convert2h5'
export ARCUBE_INDEX='0'


globalIdx=$ARCUBE_INDEX
echo "globalIdx is $globalIdx"

outDir=$PWD/output/$ARCUBE_OUT_NAME
mkdir -p $outDir

outName=$ARCUBE_OUT_NAME.$(printf "%05d" "$globalIdx")
inName=$ARCUBE_SPILL_NAME.$(printf "%05d" "$globalIdx")
echo "outName is $outName"

timeFile=$outDir/TIMING/$outName.time
mkdir -p "$(dirname "$timeFile")"
timeProg=$PWD/../run-edep-sim/tmp_bin/time      # container is missing /usr/bin/time

run() {
    echo RUNNING "$@"
    time "$timeProg" --append -f "$1 %P %M %E" -o "$timeFile" "$@"
}

inFile=$PWD/../run-spill-build/output/${ARCUBE_SPILL_NAME}/EDEPSIM_SPILLS/${inName}.EDEPSIM_SPILLS.root

h5OutDir=$outDir/EDEPSIM_H5
mkdir -p $h5OutDir

outFile=$h5OutDir/${outName}.EDEPSIM.h5
rm -f $outFile


run python convert_edepsim_roottoh5.py --input_file $inFile --output_file $outFile