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
! ({ env --unset _JAVA_OPTIONS make nativelink && cd ./one && timeout 3s yes a | ./target/one ; })

# Test that an empty stdin works.
! printf '' | ./one/target/one --n 1
! printf '' | ./one/target/one --n 0
! printf 'non_empty' | ./one/target/one --n 0
printf '' | ./one/target/one --empty
! printf 'non_empty' | ./one/target/one --empty

# vim: set filetype=sh fileformat=unix nowrap:
