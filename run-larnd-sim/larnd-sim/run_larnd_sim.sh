#!/usr/bin/env bash
# module load gcc/8.5.0-ede2bck

#ON SWING MACHINES
# module load anaconda3/2023-01-11

# export ARCUBE_CONVERT2H5_NAME='test_MiniRun3.convert2h5'
# export ARCUBE_OUT_NAME='test_MiniRun3.larnd'
# export ARCUBE_INDEX='3'


seed=$((1 + ARCUBE_INDEX))

globalIdx=$ARCUBE_INDEX
echo "globalIdx is $globalIdx"

inDir=$PWD/../../run-convert2h5/output/$ARCUBE_CONVERT2H5_NAME

outDir=$PWD/../output/$ARCUBE_OUT_NAME
mkdir -p $outDir

outName=$ARCUBE_OUT_NAME.$(printf "%05d" "$globalIdx")
inName=$ARCUBE_CONVERT2H5_NAME.$(printf "%05d" "$globalIdx")
echo "outName is $outName"

timeFile=$outDir/TIMING/$outName.time
mkdir -p "$(dirname "$timeFile")"
timeProg=/usr/bin/time

run() {
    echo RUNNING "$@"
    time "$timeProg" --append -f "$1 %P %M %E" -o "$timeFile" "$@"
}

inFile=$inDir/EDEPSIM_H5/${inName}.EDEPSIM.h5

larndOutDir=$outDir/LARNDSIM
mkdir -p $larndOutDir

outFile=$larndOutDir/${outName}.LARNDSIM.h5
rm -f "$outFile"

run ./simulate_pixels.py --input_filename "$inFile" \
    --output_filename "$outFile" \
    --detector_properties ./larndsim/detector_properties/2x2.yaml \
    --pixel_layout ./larndsim/pixel_layouts/multi_tile_layout-2.3.16.yaml \
    --response_file ./larndsim/bin/response_44.npy \
    --light_lut_filename /lcrc/project/LCRC_for_DUNE/products/larndsim/lightLUT_M123.npz \
    --light_det_noise_filename ./larndsim/bin/light_noise-2x2-example.npy \
    --rand_seed $seed \
    --simulation_properties ./larndsim/simulation_properties/2x2_NuMI_sim.yaml
