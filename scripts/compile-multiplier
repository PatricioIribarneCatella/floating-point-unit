#!/usr/bin/env bash

set -eu

SIMDIR="simul"
GHDLFLAGS="--ieee=standard -fsynopsys --warn-no-vital-generic --workdir=$SIMDIR"

COMPONENT="float_multiplier"

UTILS="testbench/utils/*"
SRCFILES="src/*"

mkdir -p $SIMDIR
ghdl -i $GHDLFLAGS --work=work testbench/$COMPONENT"_tb.vhdl" $UTILS $SRCFILES
ghdl -m $GHDLFLAGS --work=work $COMPONENT"_tb"
