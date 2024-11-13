#!/usr/bin/env bash

# Halt on error.
set -euo pipefail

# Go to execution directory.
cd "$(git rev-parse --show-toplevel)"
[[ -d ./.git ]]

[[ $(whoami) != 'user_one' ]]

bash -xv ./other/tests/host/test_no_cli.sh

bash -xv ./other/tests/host/test_cli.sh

# vim: set filetype=sh fileformat=unix nowrap:
