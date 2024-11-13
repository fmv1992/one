#!/usr/bin/env bash

# Halt on error.
set -euo pipefail

# Go to execution directory.
cd "$(git rev-parse --show-toplevel)"
[[ -d ./.git ]]

[[ $(whoami) != 'user_one' ]]

# Actual test area. --- {{{

./bin/one --help

! ./bin/one --no-option

! cmp <(echo -n 'a\nb\nc') <({
    echo 'a'
    echo 'b'
    echo 'c'
} | ./bin/one --lines 2 || true )

cmp <(printf '%s\n' y y y y y y y y y y) <(yes | head --lines 10 | ./bin/one --lines 10)

# Ensure that it fails wo segmentation fault.
n_big=50000
stdout_and_err="$({ yes 'abcde' | head --lines $n_big | ./bin/one --lines $n_big; } 2>&1 | paste --serial --delimiters ' ' || true)"
[[ -n ${stdout_and_err} ]]
if [[ ${stdout_and_err} =~ .*[Ss]egmentation.* ]]; then
    echo "Segmentation fault unexpected." >&2
    exit 1
fi

! cmp <(echo -n 'a\nb') <(echo 'a' | ./bin/one --lines 2)

# --- }}}

# Test the empty flag. --- {{{

# Simple test.
printf '' | ./bin/one --empty

! printf 'a' | ./bin/one --empty

# --- }}}

# Test invalid CLI combination options. --- {{{

! ./bin/one --empty --lines 10

# --- }}}

# vim: set filetype=sh fileformat=unix nowrap:
