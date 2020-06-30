#!/usr/bin/env bash

set -eu

SIMDIR="simul"
STOPTIME="500ns"

COMPONENT=$1
SIMBIN=$COMPONENT"_tb"

SIMFLAGS="--stop-time=$STOPTIME --vcdgz=$SIMDIR/$SIMBIN.vcdgz"
GHDLFLAGS="--ieee=standard -fsynopsys --warn-no-vital-generic --workdir=$SIMDIR"

mkdir -p $SIMDIR
ghdl -r $GHDLFLAGS $SIMBIN $SIMFLAGS
