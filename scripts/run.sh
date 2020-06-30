#!/usr/bin/env bash

set -eu

COMPONENT=$1

./scripts/compile.sh $COMPONENT
./scripts/simul.sh $COMPONENT
