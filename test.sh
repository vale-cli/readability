#!/bin/sh
#
# Each rule carries its cases in a `tests:` block, run in isolation by
# `vale test`, which with `--coverage` also requires every rule to fire in
# some case.
set -eu
root=$(cd "$(dirname "$0")" && pwd)
vale=${VALE:-vale}
cd "$root" && "$vale" test --coverage Readability
