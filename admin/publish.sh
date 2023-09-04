#!/bin/bash

run=MicroRun3

# Move the edep sim output to publish folder
cp -r ../run-edep-sim/output/$run.nu ../../2x2_files/MicroRun3.1_1E18_RHC/
cp -r ../run-edep-sim/output/$run.rock ../../2x2_files/MicroRun3.1_1E18_RHC/

# Move the spill files
cp -r ../run-spill-build/output/$run.spill ../../2x2_files/MicroRun3.1_1E18_RHC/

# Move the convert2h5 files
cp -r ../run-convert2h5/output/$run.convert2h5 ../../2x2_files/MicroRun3.1_1E18_RHC/

# Move the larndfiles files
cp -r ../run-larnd-sim/output/$run.larnd ../../2x2_files/MicroRun3.1_1E18_RHC/

# Move the flow files
cp -r ../run-ndlar-flow/output/$run.flow ../../2x2_files/MicroRun3.1_1E18_RHC/

echo "Done!"