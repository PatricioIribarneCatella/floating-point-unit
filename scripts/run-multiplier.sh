#!/usr/bin/env bash

set -eu

FILE=$1

./scripts/generate-tb.py $FILE
./scripts/compile-multiplier.sh
./scripts/simul-multiplier.sh

#while [[ $# -gt 0 ]]; do
#	file=$1
#	./scripts/generate-tb.py $file
#	./scripts/compile-multiplier.sh
#	./scripts/simul-multiplier.sh $file
#	shift
#done
