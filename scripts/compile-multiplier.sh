#!/usr/bin/env bash

SIMDIR="simul"
GHDLFLAGS="--ieee=standard -fsynopsys --warn-no-vital-generic --workdir=$SIMDIR"

COMPONENT="float_multiplier"
#COMPONENT="fm"

UTILS="testbench/utils/*"
SRCFILES="src/*"

ghdl -i $GHDLFLAGS --work=work testbench/$COMPONENT"_tb.vhdl" $UTILS $SRCFILES
ghdl -m $GHDLFLAGS --work=work $COMPONENT"_tb"
