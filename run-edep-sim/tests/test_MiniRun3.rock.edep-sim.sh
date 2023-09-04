#!/usr/bin/env bash


#LCRC for DUNE specific dependancies
source /cvmfs/dune.opensciencegrid.org/products/dune/setup_dune.sh
setup dk2nugenie v01_10_01k -q e20:prof
setup genie_xsec v3_04_00   -q AR2320i00000:e1000:k250
setup dune_oslibs v1_0_0

#EDEP SIM VARIABLES
export GEN_DIR=/lcrc/project/LCRC_for_DUNE/users/fathima
export EDEPSIM=$GEN_DIR/edep-sim/install
export LD_LIBRARY_PATH=$EDEPSIM/lib:$LD_LIBRARY_PATH
export PATH=$EDEPSIM/bin:$PATH
export EDEPSIM_ROOT=$(dirname $(which edep-sim))/..

export ARCUBE_INDEX=0
export ARCUBE_CHERRYPICK='0'
export ARCUBE_DET_LOCATION='ProtoDUNE-ND-Rock'
export ARCUBE_DK2NU_DIR='/lcrc/project/LCRC_for_DUNE/users/fathima/2x2_sim/2x2EventGeneration/NuMI_dk2nu/newtarget-200kA_20220409'
export ARCUBE_EDEP_MAC='macros/2x2_beam.mac'
export ARCUBE_EXPOSURE='1E12'
export ARCUBE_GEOM='geometry/Merged2x2MINERvA_v2/Merged2x2MINERvA_v2_justRock.gdml'
export ARCUBE_GEOM_EDEP='geometry/Merged2x2MINERvA_v2/Merged2x2MINERvA_v2_withRock.gdml'
export ARCUBE_TUNE='D22_22a_02_11b'
export ARCUBE_XSEC_FILE='/lcrc/project/LCRC_for_DUNE/products/splines/D22_22a_02_11b.all.LFG_testing.20230228.spline.xml'
export ARCUBE_OUT_NAME='test_MiniRun3.rock'


./run_edep_sim.sh

