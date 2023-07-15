#!/usr/bin/env bash




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
# export GENIE=$GEN_DIR/Generator
# export DK2NU=$GEN_DIR/dk2nu
export EDEPSIM=$GEN_DIR/edep-sim/install

# export LD_LIBRARY_PATH=$GENIE/lib:$GENIE/lib:$DK2NU/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$LIBXML2_LIB:$LHAPDF_LIB:$PYTHIA6:$EDEPSIM/lib:$LD_LIBRARY_PATH
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
export ARCUBE_NU_NAME='test_MiniRun3.nu.hadd'
export ARCUBE_NU_POT='1E15'
export ARCUBE_ROCK_NAME='test_MiniRun3.rock.hadd'
export ARCUBE_ROCK_POT='1E15'
export ARCUBE_OUT_NAME='test_MiniRun3.spill'
export ARCUBE_INDEX='0'


# root -l -b -q 'overlaySinglesIntoSpills.C("/global/cfs/cdirs/dune/users/mkramer/mywork/2x2_sim/run-edep-sim/output/MiniRun1_1E19_RHC_nu/EDEPSIM/g4numiv6_minervame_me000z-200i_0_0001.000.EDEPSIM.root","/global/cfs/cdirs/dune/users/mkramer/mywork/2x2_sim/run-edep-sim/output/MiniRun1_1E19_RHC_rock/EDEPSIM/g4numiv6_minervame_me000z-200i_0_0001.000.EDEPSIM.root","test_multiSpill.root",2E15,5E14)'

# # Reload in Shifter if necessary
# if [[ "$SHIFTER_IMAGEREQUEST" != "$ARCUBE_CONTAINER" ]]; then
#     shifter --image=$ARCUBE_CONTAINER --module=none -- "$0" "$@"
#     exit
# fi

# source /environment             # provided by the container

globalIdx=$ARCUBE_INDEX
echo "globalIdx is $globalIdx"

outName=$ARCUBE_OUT_NAME.$(printf "%05d" "$globalIdx")
nuName=$ARCUBE_NU_NAME.$(printf "%05d" "$globalIdx")
rockName=$ARCUBE_ROCK_NAME.$(printf "%05d" "$globalIdx")
echo "outName is $outName"

inBaseDir=$PWD/../run-edep-sim/output
nuInDir=$inBaseDir/$ARCUBE_NU_NAME
rockInDir=$inBaseDir/$ARCUBE_ROCK_NAME

nuInFile=$nuInDir/EDEPSIM/${nuName}.EDEPSIM.root
rockInFile=$rockInDir/EDEPSIM/${rockName}.EDEPSIM.root

outDir=$PWD/output/$ARCUBE_OUT_NAME
mkdir -p "$outDir"

timeFile=$outDir/TIMING/$outName.time
mkdir -p "$(dirname "$timeFile")"
timeProg=$PWD/../run-edep-sim/tmp_bin/time      # container is missing /usr/bin/time

run() {
    echo RUNNING "$@"
    time "$timeProg" --append -f "$1 %P %M %E" -o "$timeFile" "$@"
}

spillOutDir=$outDir/EDEPSIM_SPILLS
mkdir -p "$spillOutDir"

spillFile=$spillOutDir/${outName}.EDEPSIM_SPILLS.root
rm -f "$spillFile"

# run root -l -b -q \
#     -e "gInterpreter->AddIncludePath(\"/opt/generators/edep-sim/install/include/EDepSim\")" \
#     "overlaySinglesIntoSpills.C(\"$nuInFile\", \"$rockInFile\", \"$spillFile\", $ARCUBE_NU_POT, $ARCUBE_ROCK_POT)"

# HACK: We need to "unload" edep-sim; if it's in our LD_LIBRARY_PATH, we have to
# use the "official" edepsim-io headers, which force us to use the getters, at
# least when using cling(?). overlaySinglesIntoSpills.C directly accesses the
# fields. So we apparently must use headers produced by MakeProject, but that
# would lead to a conflict with the ones from the edep-sim installation. Hence
# we unload the latter. Fun. See makeLibTG4Event.sh

function libpath_remove {
  LD_LIBRARY_PATH=":$LD_LIBRARY_PATH:"
  LD_LIBRARY_PATH=${LD_LIBRARY_PATH//":"/"::"}
  LD_LIBRARY_PATH=${LD_LIBRARY_PATH//":$1:"/}
  LD_LIBRARY_PATH=${LD_LIBRARY_PATH//"::"/":"}
  LD_LIBRARY_PATH=${LD_LIBRARY_PATH#:}; LD_LIBRARY_PATH=${LD_LIBRARY_PATH%:}
}

libpath_remove /opt/generators/edep-sim/install/lib

# run root -l -b -q \
#     -e "gInterpreter->AddIncludePath(\"libTG4Event\")" \
#     "overlaySinglesIntoSpills.C(\"$nuInFile\", \"$rockInFile\", \"$spillFile\", $ARCUBE_NU_POT, $ARCUBE_ROCK_POT)"

# run root -l -b -q \
#     -e "gSystem->Load(\"libTG4Event/libTG4Event.so\")" \
#     "overlaySinglesIntoSpills.C(\"$nuInFile\", \"$rockInFile\", \"$spillFile\", $ARCUBE_NU_POT, $ARCUBE_ROCK_POT)"

run root -l -b -q \
    -e "gSystem->Load(\"libTG4Event/libTG4Event.so\")" \
    "overlaySinglesIntoSpillsSorted.C(\"$nuInFile\", \"$rockInFile\", \"$spillFile\", $globalIdx, $ARCUBE_NU_POT, $ARCUBE_ROCK_POT)"
