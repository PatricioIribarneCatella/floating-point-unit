#!/usr/bin/env bash

SIMDIR="simul"

COMPONENT="fm"
SIMBIN=$COMPONENT"_tb"

SIMFLAGS="--vcdgz=$SIMDIR/$SIMBIN.vcdgz"
GHDLFLAGS="--ieee=standard -fsynopsys --warn-no-vital-generic --workdir=$SIMDIR"

mkdir -p $SIMDIR
ghdl -r $GHDLFLAGS $SIMBIN $SIMFLAGS
