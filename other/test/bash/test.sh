#! /usr/bin/env bash

# Halt on error.
set -euo pipefail

# Go to execution directory.
{ cd "$(dirname $(readlink -f "${0}"))" && git rev-parse --is-inside-work-tree > /dev/null 2>&1 && cd "$(git rev-parse --show-toplevel)"; } || cd "$(dirname "$(readlink -f ${0})")"
# Close identation: }
test -d ./.git

! seq 1 20 | ./one/target/one

diff <(echo 'sample line' | ./one/target/one) \
    <(echo 'sample line')

# Also test an infinite sequence.
# ???

# vim: set filetype=sh fileformat=unix nowrap:
