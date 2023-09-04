#!/bin/bash

#SBATCH --job-name=2x2nu
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=ffathimamaha@anl.gov
#SBATCH --time=01:00:00

# export ARCUBE_INDEX=$((-1 + SLURM_ARRAY_TASK_ID))

#LCRC for DUNE specific dependancies
source /cvmfs/dune.opensciencegrid.org/products/dune/setup_dune.sh
setup root v6_12_06a -q e17:prof

export ARCUBE_NU_POT='1E16'
export ARCUBE_ROCK_POT='1E12'
export ARCUBE_NU_NAME='MicroRun3.nu'
export ARCUBE_ROCK_NAME='MicroRun3.rock'
export ARCUBE_OUT_NAME='MicroRun3.spill'

./run_spill_build.sh