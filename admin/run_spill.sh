#!/bin/bash

run=MicroRun3.1_1E18_RHC
logdir=../../2x2_files/$run/logs

pushd $logdir
    rm -f ./error/spill/*
    rm -f ./output/spill/*
popd

submit_array_job() {
    local array_values=("${@}")  # Passed array as arguments
    local array_values_string="${array_values[@]}"
    
    echo "Submitting array job with values: ${array_values_string}"

    pushd ../run-spill-build
    for i in $(seq 28 $NUM_ITERATIONS)
    do  
        export ARCUBE_INDEX=$i;
        sbatch --array=[${array_values_string}] -p knl-preemptable  -o $logdir/output/rock/slurm-%j_out.txt --error=$logdir/error/rock/slurm-%j_error.txt --account=LCRC_for_DUNE ./runs/MicroRun3.spill.edep-sim.sh
    done
    popd
}

read -p "Do you want to rerun the job? (y/n): " rerun_choice

if [ "$rerun_choice" = "y" ]; then
    read -p "Enter integers for the array (comma-separated): " -a integers_array

    if [ ${#integers_array[@]} -eq 0 ]; then
        echo "Array is empty. Exiting."
        exit 1
    fi

    submit_array_job "${integers_array[@]}"
else
    integers_array=($(seq -s, 1 100))
    submit_array_job "${integers_array[@]}"
fi

#sacct -j 2942293 --format=JobID,Start,End,Elapsed,ExitCode > jobStatus.txt
