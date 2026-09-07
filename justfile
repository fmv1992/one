#!/usr/bin/env just --justfile

set shell := ["bash", "-euo", "pipefail", "-c"]

export VERSION := shell('cat ./.version')

export ROOT_DIR := shell('dirname "$(readlink --canonicalize "${BASH_SOURCE:-$0}")"')
export PROJECT := "one"
export USER_UID := shell('id --user')
export USER_GID := shell('id --group')

DOCKER_COMPOSE_FILE := "./compose.yaml"
DOCKER_COMPOSE_CMD := "docker compose"
DOCKER_RUN_CMD := env("DOCKER_RUN_CMD", "/usr/bin/dumb-init -- bash")

export GIT_COMMIT := shell('git show --no-patch --format=%H 2>/dev/null || echo "no_git"')

DOCKER_BUILD_ARGS := ("--progress=plain"
    + " --build-arg BASE_IMAGE='ubuntu:22.04'"
    + " --build-arg USER_UID='"
    + USER_UID
    + "' --build-arg USER_GID='"
    + USER_GID
    + "' --build-arg GIT_COMMIT='"
    + GIT_COMMIT
    + "' --build-arg GIT_COMMIT_DATE='"
    + shell('git show --no-patch --date=iso8601 --format=%ci 2>/dev/null || echo "no_git"')
    + "' --build-arg PROJECT='"
    + PROJECT
    + "' --build-arg IMAGE_NAME='"
    + PROJECT
    + "' --build-arg BUILD_DATE='"
    + shell('date --iso-8601=seconds')
    + "'")

# Section. --- {{{

# Default recipe.
all: dev check build test package format

# Development setup.
dev:
    cp --recursive --force ./other/git/hooks/* ./.git/hooks/

# Start containers.
up:
    {{ DOCKER_COMPOSE_CMD }} --file {{ DOCKER_COMPOSE_FILE }} up --detach

# Stop and remove containers.
down:
    {{ DOCKER_COMPOSE_CMD }} --file {{ DOCKER_COMPOSE_FILE }} down --remove-orphans --volumes --timeout 10

# Remove all containers matching project name.
down_all_containers:
    docker ps --all --filter "name={{ PROJECT }}" --format "{{{{.ID}}" \
            | xargs --no-run-if-empty --replace={} docker rm --force --volumes {}

# Run container with command.
run:
    #!/usr/bin/env bash
    set -Eeuo pipefail
    if [ -t 0 ] && [ -t 1 ]; then
        export DOCKER_STDIN_OPEN=true
        export DOCKER_TTY=true
        TTY_FLAG=""
    else
        export DOCKER_STDIN_OPEN=false
        export DOCKER_TTY=false
        TTY_FLAG="--no-TTY"
    fi
    {{ DOCKER_COMPOSE_CMD }} \
            --file {{ DOCKER_COMPOSE_FILE }} \
            run \
            --rm \
            ${TTY_FLAG} \
            one \
            {{ DOCKER_RUN_CMD }}

# Exec into a running docker.
docker_exec:
    {{ DOCKER_COMPOSE_CMD }} exec {{ PROJECT }} {{ DOCKER_RUN_CMD }}

# Shell access.
shell:

# Build Docker images.
build:
    {{ DOCKER_COMPOSE_CMD }} --file {{ DOCKER_COMPOSE_FILE }} build {{ DOCKER_BUILD_ARGS }}

# Run checks.
check:

# Run tests.
test: test_ada test_unit_test test_package_test

# Run Ada tests.
test_ada:
    #!/usr/bin/env bash
    set -Eeuo pipefail
    set -x
    rm ./tmp/.test_mark.txt &> /dev/null || true
    alr test
    [[ -f ./tmp/.test_mark.txt ]]

test_unit_test:
    set -x ; DOCKER_RUN_CMD='bash -c '"'"'bash -xv ./other/tests/test.sh'"'" just run

_TEST_PACKAGE_SCRIPT := '''
bash -c '
set -Eeuo pipefail
cd "${HOME}/${PROJECT}"

echo "Installing package."
# ̶s̶̶̶u̶̶̶d̶̶̶o̶̶ ̶a̶̶̶p̶̶̶t̶̶̶-̶̶̶g̶̶̶e̶̶̶t̶̶ ̶u̶̶̶p̶̶̶d̶̶̶a̶̶̶t̶̶̶e̶̶
sudo apt-get install -y "./dist/${PROJECT}.deb"

echo "Verifying installation."
if ! command -v "${PROJECT}" &> /dev/null; then
    echo "❌ Error: Binary ${PROJECT} not found in PATH."
    exit 1
fi

# Run the binary to ensure it executes (assuming --help works)
"${PROJECT}" --help
"${PROJECT}" --version
echo "Package installed and ran successfully."
'
'''

test_package_test: package
    # We rely on the internal "bash -c" inside the script variable,
    # so we just need to quote it safely for the shell.
    DOCKER_RUN_CMD={{ quote(_TEST_PACKAGE_SCRIPT) }} just run

# Define the inner script cleanly using triple quotes.
_NFPM_SCRIPT := '''
bash -c '
set -Eeuo pipefail
set -x
cd "${HOME}/${PROJECT}"
[[ -n "${VERSION}" ]]
[[ -n "${GIT_COMMIT}" ]]
# Regex substitute the version and git commit.
echo "ZmluZCAiJHtIT01FfS8ke1BST0pFQ1R9IiAtdHlwZSBmIC1wcmludDAgXAogICAgfCBwYXJhbGxlbCBcCiAgICAgICAgLS1uby1ydW4taWYtZW1wdHkgXAogICAgICAgIC0tbnVsbCBcCiAgICAgICAgLS1ncm91cCBcCiAgICAgICAgLS1rZWVwLW9yZGVyIFwKICAgICAgICAtLWpvYnMgJChucHJvYykgXAogICAgICAgIC0tbWF4LWFyZ3MgMSBcCiAgICAgICAgLS0gXAogICAgICAgICcKc2V0IC1FZXVvIHBpcGVmYWlsCltbIC1uICIke1ZFUlNJT059IiBdXQpbWyAtbiAiJHtHSVRfQ09NTUlUfSIgXV0Kc2VkIC0tcmVnZXhwLWV4dGVuZGVkICJzI+G8gM+BzrnOuM684b24z4JfzrPOtc69zrXhv4bPgiMke1ZFUlNJT059I2ciIC0tIHt9IFwKICAgIHwgc2VkIC0tcmVnZXhwLWV4dGVuZGVkICJzI86zzrnPhF/Pg8+Fzr3OuM61z4POr863IyR7R0lUX0NPTU1JVH0jZyIgLS0gPiAvdG1wL3sjfQpjYXQgL3RtcC97I30gPiB7fQogICAgICAgICcKCiMgdmltOiBzZXQgZmlsZXR5cGU9c2ggZmlsZWZvcm1hdD11bml4IG5vd3JhcCBzcGVsbCBzcGVsbGxhbmc9ZW4sY2RlbmdsaXNoMDE6Cg==" | base64 --decode | bash -xv -
env DIST_DIR="./dist" nfpm package --config ./nfpm.yaml --packager deb --target "./dist/${PROJECT}.deb"
  '
'''

# Build `.deb` package using `nfpm` inside docker.
package:
    DOCKER_RUN_CMD={{ quote(_NFPM_SCRIPT) }} just run
# Format all files.
format: format_yaml format_json format_rec

# Format YAML files.
format_yaml:
    find {{ ROOT_DIR }} \( -iname '*.yml' -o -iname '*.yaml' -o -iname '.yamlfmt' \) -type f -print0 | xargs --null --max-args 100 -- yamlfmt

# Format JSON files.
format_json:
    find . -iname '*.json' -print0 | parallel --null --max-args 1 -- 'python3 -m json.tool --sort-keys {} > /tmp/{{ PROJECT }}_{/}_ {}'

# Check and sort recfiles.
format_rec:
    #! /usr/bin/env bash
    set -Eeuo pipefail
    find . -iname '*.rec' -type f -print0 \
        | parallel \
            --no-run-if-empty \
            --null \
            --group \
            --keep-order \
            --jobs $(nproc) \
            --max-args 1 \
            -- \
            '
    set -euo pipefail
    if recfix --check -- {} && recfix --sort -- {}; then
        echo "✔: {}"
    else
        echo "✘: {}"
    fi
    '

#  --- }}}

# vim: set foldmethod=marker fileformat=unix filetype=just nowrap foldmarker={{{,}}} :
