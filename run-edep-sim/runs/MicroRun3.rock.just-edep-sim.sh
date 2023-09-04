#!/usr/bin/env bash

#SBATCH --job-name=2x2rock
#SBATCH –-partition=knl-preemptable
#SBATCH –-requeue
#SBATCH --mail-type=REQUEUE
#SBATCH --mail-user=ffathimamaha@anl.gov
#SBATCH --time=00:05:00

export ARCUBE_INDEX=$((-1 + SLURM_ARRAY_TASK_ID))


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


export ARCUBE_CHERRYPICK='0'
export ARCUBE_DET_LOCATION='ProtoDUNE-ND-Rock'
export ARCUBE_DK2NU_DIR='/lcrc/project/LCRC_for_DUNE/users/fathima/2x2_sim/2x2EventGeneration/NuMI_dk2nu/newtarget-200kA_20220409'
export ARCUBE_EDEP_MAC='macros/2x2_beam.mac'
#lesser pots because of cpu hours used by rock events
export ARCUBE_EXPOSURE='1E12'
export ARCUBE_GEOM='geometry/Merged2x2MINERvA_v2/Merged2x2MINERvA_v2_justRock.gdml'
export ARCUBE_GEOM_EDEP='geometry/Merged2x2MINERvA_v2/Merged2x2MINERvA_v2_withRock.gdml'
export ARCUBE_TUNE='AR23_20i_00_000'
export ARCUBE_XSEC_FILE='/lcrc/project/LCRC_for_DUNE/products/splines/genie_xsec/v3_04_00/NULL/AR2320i00000-k250-e1000/data/gxspl-NUsmall.xml'
export ARCUBE_OUT_NAME='MicroRun3.rock'

./run_edep_sim.sh

