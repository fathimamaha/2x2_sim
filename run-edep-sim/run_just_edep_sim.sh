# Start seeds at 1 instead of 0, just in case GENIE does something
# weird when given zero (e.g. use the current time)
# NOTE: We just use the fixed Edep default seed of

echo "Arcube Index is $ARCUBE_INDEX"

if [ $SEEDCORRECTION = 1 ]; then
    seed=$((1000 + ARCUBE_INDEX))
else
    seed=$((1 + ARCUBE_INDEX))
fi

echo "Seed is $seed"

globalIdx=$ARCUBE_INDEX
echo "globalIdx is $globalIdx"

dk2nuAll=("$ARCUBE_DK2NU_DIR"/*.dk2nu)
dk2nuCount=${#dk2nuAll[@]}
dk2nuIdx=$((globalIdx % dk2nuCount))
dk2nuFile=${dk2nuAll[$dk2nuIdx]}
echo "dk2nuIdx is $dk2nuIdx"
echo "dk2nuFile is $dk2nuFile"

outDir=$PWD/output/$ARCUBE_OUT_NAME
outName=$ARCUBE_OUT_NAME.$(printf "%05d" "$globalIdx")
echo "outName is $outName"

timeFile=$outDir/TIMING/$outName.time
mkdir -p "$(dirname "$timeFile")"
timeProg=$PWD/tmp_bin/time      # container is missing /usr/bin/time

run() {
    echo RUNNING "$@"
    time "$timeProg" --append -f "$1 %P %M %E" -o "$timeFile" "$@"
}

export GXMLPATH=$PWD/flux            # contains GNuMIFlux.xml
maxPathFile=$PWD/maxpath/$(basename "$ARCUBE_GEOM" .gdml).$ARCUBE_TUNE.maxpath.xml
genieOutPrefix=$outDir/GENIE/$outName
mkdir -p "$(dirname "$genieOutPrefix")"
export GXMLPATH=/lcrc/project/LCRC_for_DUNE/users/fathima/2x2_sim/run-edep-sim:${GXMLPATH}

# HACK: gevgen_fnal hardcodes the name of the status file (unlike gevgen, which
# respects -o), so run it in a temporary directory. Need to get absolute paths.

dk2nuFile=$(realpath "$dk2nuFile")
ARCUBE_GEOM=$(realpath "$ARCUBE_GEOM")
ARCUBE_XSEC_FILE=$(realpath "$ARCUBE_XSEC_FILE")

source /cvmfs/dune.opensciencegrid.org/products/dune/setup_dune.sh


#----------#

#Setting up geant and root separately
#for what has been built with edepsim
setup geant4 v4_10_3_p03e -q e17:prof
setup root v6_12_06a -q e17:prof


if [[ "$ARCUBE_CHERRYPICK" == 1 ]]; then
    run ./cherrypicker.py -i "$genieOutPrefix".0.gtrac.root \
        -o "$genieOutPrefix".0.gtrac.cherry.root
    genieFile="$genieOutPrefix".0.gtrac.cherry.root
else
    echo "ENTERED"
    genieFile="$genieOutPrefix".0.gtrac.root
fi

rootCode='
auto t = (TTree*) _file0->Get("gRooTracker");
std::cout << t->GetEntries() << std::endl;'
nEvents=$(echo "$rootCode" | root -l -b "$genieFile" | tail -1)

edepRootFile=$outDir/EDEPSIM/${outName}.EDEPSIM.root
mkdir -p "$(dirname "$edepRootFile")"
rm -f "$edepRootFile"

edepCode="/generator/kinematics/rooTracker/input $genieFile
/edep/runId $ARCUBE_INDEX"

export ARCUBE_GEOM_EDEP=${ARCUBE_GEOM_EDEP:-$ARCUBE_GEOM}

run edep-sim -C -g "$ARCUBE_GEOM_EDEP" -o "$edepRootFile" -e "$nEvents" \
    <(echo "$edepCode") "$ARCUBE_EDEP_MAC"
