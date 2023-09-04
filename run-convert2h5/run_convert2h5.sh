#!/bin/bash

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