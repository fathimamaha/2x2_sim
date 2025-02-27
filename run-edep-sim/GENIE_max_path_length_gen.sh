#!/bin/bash

# Reload in Shifter if necessary
if [[ "$SHIFTER_IMAGEREQUEST" != "$ARCUBE_CONTAINER" ]]; then
	shifter --image=$ARCUBE_CONTAINER --module=none -- "$0" "$@"
	exit
fi

geom=$1; shift
tune=$1; shift

seed=0
npoints=1000
nrays=1000

maxpath=maxpath/$(basename "$geom" .gdml).$tune.maxpath.xml
mkdir -p "$(dirname "$maxpath")"

source /environment

gmxpl \
	-f "$geom" \
	-L cm -D g_cm3 \
	-o "$maxpath" \
	-n "$npoints" \
	-r "$nrays" \
	--tune "$tune" \
	--seed "$seed"
