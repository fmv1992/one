#! /usr/bin/env bash

# Halt on error.
set -euo pipefail

# Go to execution directory.
cd "$(dirname $(readlink -f "${0}"))"

[[ $(whoami) == 'user_one' ]]

[[ $(sudo whoami) != 'root' ]]

# vim: set filetype=sh fileformat=unix nowrap:
