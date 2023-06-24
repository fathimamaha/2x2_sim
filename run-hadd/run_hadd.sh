#!/usr/bin/env bash


cd /lcrc/project/LCRC_for_DUNE/users/fathima/2x2_sim/run-edep-sim

#LCRC for DUNE specific dependancies
source /cvmfs/dune.opensciencegrid.org/products/dune/setup_dune.sh
setup gcc v7_3_0
setup root v6_12_06a -q e17:prof
setup pythia v6_4_28p -q gcc730:prof
setup lhapdf v6_2_3 -q e17:prof
setup libxml2 v2_9_9 -q prof
setup log4cpp v1_1_3b -q e17:prof
setup geant4 v4_10_3_p03e -q e17:prof


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
export LD_LIBRARY_PATH=$LIBXML2_LIB:$LHAPDF_LIB:$PYTHIA6:$GENIE/lib:$EDEPSIM/lib:$DK2NU/lib:$LD_LIBRARY_PATH
export PATH=$EDEPSIM/bin:$GENIE/bin:$PATH

export EDEPSIM_ROOT=$(dirname $(which edep-sim))/..


#EDEP SIM VARIABLES
export ARCUBE_CHERRYPICK='0'
export ARCUBE_DET_LOCATION='ProtoDUNE-ND'
export ARCUBE_DK2NU_DIR='/lcrc/project/LCRC_for_DUNE/users/fathima/2x2_sim/2x2EventGeneration/NuMI_dk2nu/newtarget-200kA_20220409'
export ARCUBE_EDEP_MAC='macros/2x2_beam.mac'
export ARCUBE_EXPOSURE='1E15'
export ARCUBE_GEOM='geometry/Merged2x2MINERvA_v2/Merged2x2MINERvA_v2_noRock.gdml'
export ARCUBE_GEOM_EDEP='geometry/Merged2x2MINERvA_v2/Merged2x2MINERvA_v2_withRock.gdml'
export ARCUBE_TUNE='D22_22a_02_11b'
export ARCUBE_XSEC_FILE='/lcrc/project/LCRC_for_DUNE/products/splines/D22_22a_02_11b.all.LFG_testing.20230228.spline.xml'
# export ARCUBE_OUT_NAME='test_MiniRun3.nu'

# export ARCUBE_CONTAINER='mjkramer/sim2x2:genie_edep.LFG_testing.20230228.v2'
export ARCUBE_HADD_FACTOR='10'
export ARCUBE_IN_NAME='test_MiniRun3.nu'
export ARCUBE_OUT_NAME='test_MiniRun3.nu.hadd'
export ARCUBE_INDEX='0'


# # Reload in Shifter if necessary
# if [[ "$SHIFTER_IMAGEREQUEST" != "$ARCUBE_CONTAINER" ]]; then
#     shifter --image="$ARCUBE_CONTAINER" --module=none -- "$0" "$@"
#     exit
# fi

# source /environment             # provided by the container

globalIdx=$ARCUBE_INDEX
echo "globalIdx is $globalIdx"

outDir=$PWD/../run-edep-sim/output/$ARCUBE_OUT_NAME
outName=$ARCUBE_OUT_NAME.$(printf "%05d" "$globalIdx")
echo "outName is $outName"

timeFile=$outDir/TIMING/$outName.time
mkdir -p "$(dirname "$timeFile")"
timeProg=$PWD/../run-edep-sim/tmp_bin/time # container is missing /usr/bin/time

run() {
    echo RUNNING "$@"
    time "$timeProg" --append -f "$1 %P %M %E" -o "$timeFile" "$@"
}

inDir=$PWD/../run-edep-sim/output/$ARCUBE_IN_NAME
tmpfile=$(mktemp)

for i in $(seq 0 $((ARCUBE_HADD_FACTOR - 1))); do
    inIdx=$((ARCUBE_INDEX*ARCUBE_HADD_FACTOR + i))
    inName=$ARCUBE_IN_NAME.$(printf "%05d" "$inIdx")
    inFile="$inDir"/EDEPSIM/"$inName".EDEPSIM.root
    echo "$inFile" >> "$tmpfile"
done

outFile=$outDir/EDEPSIM/${outName}.EDEPSIM.root
mkdir -p "$(dirname "$outFile")"
rm -f "$outFile"

run hadd "$outFile" "@$tmpfile"

rm "$tmpfile"
