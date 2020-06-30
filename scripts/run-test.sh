#!/usr/bin/env bash

set -eu

./scripts/compile-test.sh
./scripts/simul-test.sh
