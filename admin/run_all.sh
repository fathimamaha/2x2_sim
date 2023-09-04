#!/bin/bash

logdir=../../2x2_files/logs/logs.MicroRun3.1_1E18_RHC


#NU FILES
pushd ../run-edep-sim
    # sbatch --array=1-100 -o $logdir/output/nu/slurm-%j_out.txt --error=$logdir/error/nu/slurm-%j_error.txt -N 4 --account=LCRC_for_DUNE ./tests/test_MiniRun3.nu.edep-sim.sh
popd

# pushd ../run-edep-sim
# for i in $(seq 0 $NUM_ITERATIONS)
# do  
#     # export ARCUBE_INDEX=$i;
#     # ./tests/test_MiniRun3.nu.edep-sim.sh
#     # sbatch --job-name="2x2sim_$i" --account=LCRC_for_DUNE --time=15:00:00 --output=/dev/null --error="../admin/error_$i.stderr" ./tests/test_MiniRun3.nu.edep-sim.sh
#     #sbatch --job-name="2x2sim_$i" --account=LCRC_for_DUNE --time=24:00:00 --output=/dev/null --error="../admin/error_$i.stderr" ./tests/test_MiniRun3.rock.edep-sim.sh 
# done
# popd

# # pushd run-hadd
# # ./tests/test_MiniRun3.nu.hadd.sh
# # ./tests/test_MiniRun3.rock.hadd.sh
# # popd

# pushd ../run-spill-build
# for i in $(seq 28 $NUM_ITERATIONS)
# do  
#      export ARCUBE_INDEX=$i;
#      #sbatch --job-name="2x2sim_$i" --account=LCRC_for_DUNE --time=15:00:00 --output="../admin/output_$i.stdout" --error="../admin/error_$i.stderr" ./run_spill_build.sh
# done
# popd

# pushd ../run-convert2h5
# for i in $(seq 0 $NUM_ITERATIONS)
# do
#      export ARCUBE_INDEX=$i;
#      #sbatch --job-name="2x2sim_$i" --account=LCRC_for_DUNE --time=15:00:00 --output="../admin/output_$i.stdout" --error="../admin/error_$i.stderr" ./run_convert2h5.sh
# # ./run_convert2h5.sh
# done
# popd

# pushd ../run-larnd-sim/larnd-sim
# for i in $(seq 17 $NUM_ITERATIONS)
# do
#      export ARCUBE_INDEX=$i;
#      #./run_larnd_sim.sh     
# #sbatch --job-name="2x2sim_$i" --account=LCRC_for_DUNE --time=00:10:00 --output="../admin/output_$i.stdout" --error="../admin/error_$i.stderr" --gres=gpu:1 ./run_larnd_sim.sh
# # ./run_convert2h5.sh
# done
# # ./install_larnd_sim.sh
# popd

# pushd ../run-ndlar-flow

# for i in $(seq 0 15)
# do
#      export ARCUBE_INDEX=$i;
#      #sbatch --job-name="2x2sim_$i" --account=LCRC_for_DUNE --time=15:00:00 --output="../admin/output_$i.stdout" --error="../admin/error_$i.stderr" ./run_ndlar_flow.sh
#      #./run_ndlar_flow.sh
# done
# for i in $(seq 17 27)
# do
#      export ARCUBE_INDEX=$i;
#      #sbatch --job-name="2x2sim_$i" --account=LCRC_for_DUNE --time=15:00:00 --output="../admin/output_$i.stdout" --error="../admin/error_$i.stderr" ./run_ndlar_flow.sh
#      #./run_ndlar_flow.sh
# done
# popd

# # pushd validation
# # ./install_validation.sh
# # popd
