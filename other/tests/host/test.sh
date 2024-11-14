#!/usr/bin/env bash

# Halt on error.
set -euo pipefail

# Go to execution directory.
cd "$(git rev-parse --show-toplevel)"
[[ -d ./.git ]]

[[ $(whoami) != 'user_one' ]]

# Cover for historical bug on `6282383`. Ensure all scripts have failure on
# error enabled.
find ./other/tests -type f -iname '*test*sh' | xargs -n 1 -- grep --extended-regexp '^set -euo pipefail'

bash -xv ./other/tests/host/test_no_cli.sh

bash -xv ./other/tests/host/test_cli.sh

# vim: set filetype=sh fileformat=unix nowrap:
