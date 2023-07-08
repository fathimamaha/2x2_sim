#!/bin/bash

#LCRC for DUNE specific dependancies
source /cvmfs/dune.opensciencegrid.org/products/dune/setup_dune.sh
# setup numpy v1_14_1 -q e15:p2714b:prof -z /cvmfs/nova.opensciencegrid.org/externals/
# setup python v2_7_13d -f Linux64bit+3.10-2.17
# setup h5py v3_1_0d -q c7:p392:prof
# setup root v6_18_04d -q e19:prof

setup root v6_12_06a -q e17:prof
# setup edepsim v2_0_1 -q e17:prof
# setup python v3_7_2
which python
export GEN_DIR=/lcrc/project/LCRC_for_DUNE/users/fathima
export EDEPSIM=$GEN_DIR/edep-sim/install
export PATH=$EDEPSIM/bin:$PATH
export EDEPSIM_ROOT=$(dirname $(which edep-sim))/..
export LD_LIBRARY_PATH=$EDEPSIM/lib:$LD_LIBRARY_PATH


#installs numpy and h5py
python -m pip install h5py --user

# setup gcc v7_3_0
# setup root v6_18_04 -q e17:prof:py3
# setup pythia v6_4_28p -q gcc730:prof
# setup lhapdf v6_2_3 -q e17:prof
# setup libxml2 v2_9_9 -q prof
# setup log4cpp v1_1_3b -q e17:prof
# setup geant4 v4_10_3_p03e -q e17:prof
# setup edepsim v3_0_0 -q c7:prof
# setup 
# setup numpy v1_15_4b -q e17:p2715a:prof
# setup h5py v3_1_0d -q c7:p392:prof
# setup python v3_9_13
# setup numpy v1_22_3c -q c14:p3913

export GEN_DIR=/lcrc/project/LCRC_for_DUNE/users/fathima
export LHAPATH=/cvmfs/larsoft.opensciencegrid.org/products/lhapdf/v6_2_3/Linux64bit+3.10-2.17-e17-prof/
export PYTHIA6=/cvmfs/larsoft.opensciencegrid.org/products/pythia/v6_4_28p/Linux64bit+3.10-2.17-gcc730-prof/
export GSL_LIB=/usr/lib64
export GSL_INC=/usr/include
export LHAPDF_INC=${LHAPATH}/include
export LHAPDF_LIB=${LHAPATH}/lib
export LIBXML2_INC=/cvmfs/larsoft.opensciencegrid.org/products/libxml2/v2_9_9/Linux64bit+3.10-2.17-prof/include/libxml2/
export LIBXML2_LIB=/cvmfs/larsoft.opensciencegrid.org/products/libxml2/v2_9_9/Linux64bit+3.10-2.17-prof/lib/

#GENIE dkqu and edep-sim additionally installed
export GENIE=$GEN_DIR/Generator
export DK2NU=$GEN_DIR/dk2nu
export EDEPSIM=$GEN_DIR/edep-sim/install

export LD_LIBRARY_PATH=$GENIE/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$LIBXML2_LIB:$LHAPDF_LIB:$PYTHIA6:$GENIE/lib:$DK2NU/lib:$LD_LIBRARY_PATH
# export LD_LIBRARY_PATH=$EDEPSIM/lib:$LD_LIBRARY_PATH
# export PATH=$EDEPSIM/bin:$GENIE/bin:$PATH

# export EDEPSIM_ROOT=$(dirname $(which edep-sim))/..




export ARCUBE_CONTAINER='mjkramer/sim2x2:genie_edep.LFG_testing.20230228.v2'
export ARCUBE_SPILL_NAME='test_MiniRun3.spill'
export ARCUBE_OUT_NAME='test_MiniRun3.convert2h5'
export ARCUBE_INDEX='0'


# if [[ "$SHIFTER_IMAGEREQUEST" != "$ARCUBE_CONTAINER" ]]; then
#     shifter --image=$ARCUBE_CONTAINER --module=none -- "$0" "$@"
#     exit
# fi

# source /environment             # provided by the container

# # in the container, install numpy fire h5py tqdm
# source convert.venv/bin/activate


# source env/bin/activate

if [[ "$NERSC_HOST" == "cori" ]]; then
    export HDF5_USE_FILE_LOCKING=FALSE
fi

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

# export PYTHONHOME=/usr/bin/python3
run which python
run python convert_edepsim_roottoh5.py --input_file $inFile --output_file $outFile
