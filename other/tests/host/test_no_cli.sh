#!/usr/bin/env bash

# Halt on error.
# set -euo pipefail

# Go to execution directory.
cd "$(git rev-parse --show-toplevel)"
[[ -d ./.git ]]

[[ $(whoami) != 'user_one' ]]

# Actual test area. --- {{{

# Simple test.
[[ "$(echo 'x' | ./bin/one)" == 'x' ]]

# Ensure the new line is print.
! cmp <(printf 'x') <(echo 'x' | ./bin/one) > /dev/null 2>&1

# Define behavior on empty input.
printf ''  || true | ./bin/one || true
cmp <(printf '' || true | ./bin/one || true) <(printf '')

# Ensure program terminates.
! yes | ./bin/one
cmp <(yes | ./bin/one) <(printf '')

# # Add early termination for long running cases.
# # tag:9bbd8706
# timeout 5s bash -c '
# {
#     echo "a"
#     sleep 0.5s
#     echo "b"
#     sleep 10s
# } | ./bin/one
# echo '"'"'done'"'"' 2>&1
# '

# --- }}}

# vim: set filetype=sh fileformat=unix nowrap:
