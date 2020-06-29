#!/usr/bin/env bash

SIMDIR="simul"
GHDLFLAGS="--ieee=standard -fsynopsys --warn-no-vital-generic --workdir=$SIMDIR"

COMPONENT="fm"

UTILS="testbench/utils/*"
SRCFILES="src/*"

mkdir -p $SIMDIR
ghdl -i $GHDLFLAGS --work=work testbench/$COMPONENT"_tb.vhdl" $UTILS $SRCFILES
ghdl -m $GHDLFLAGS --work=work $COMPONENT"_tb"