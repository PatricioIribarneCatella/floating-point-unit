#!/usr/bin/env bash

set -eu

SIMDIR="simul"
GHDLFLAGS="--ieee=standard -fsynopsys --warn-no-vital-generic --workdir=$SIMDIR"

COMPONENT=$1

SRCFILES="src/$COMPONENT.vhdl"

mkdir -p $SIMDIR
ghdl -i $GHDLFLAGS --work=work testbench/$COMPONENT"_tb.vhdl" $SRCFILES
ghdl -m $GHDLFLAGS --work=work $COMPONENT"_tb"
