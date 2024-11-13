SHELL := /bin/bash -euo pipefail
export ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

export PROJECT ?= one

export USER_UID := $(shell id -u)
export USER_GID := $(shell id -g)

DOCKER_COMPOSE_FILE := ./compose.yaml

DOCKER_COMPOSE_CMD := docker compose

export GIT_COMMIT := $(or $(shell git show -s --format=%H), no_git)

TARGET ?= ./bin/one

DOCKER_BUILD_ARGS = \
    --build-arg USER_UID='$(USER_UID)' \
    --build-arg USER_GID='$(USER_GID)' \
    --build-arg GIT_COMMIT='$(GIT_COMMIT)' \
    --build-arg GIT_COMMIT_DATE='$(or $(shell git show -s --date=iso8601 --format=%ci), no_git)' \
    --build-arg PROJECT='$(PROJECT)' \
    --build-arg IMAGE_NAME='$(PROJECT)' \
    --build-arg BUILD_DATE='$(shell date --iso-8601=seconds)'

ifndef DOCKER_RUN_CMD
    DOCKER_RUN_CMD := /usr/bin/dumb-init -- bash
endif

CC := gcc-13
CFLAGS += \
    -pedantic \
    -std=c2x \
    -Wextra \
    -Wall \
    -Werror \
    -Wstrict-prototypes \
    -I ./one/include/ \
    -D GIT_COMMIT='"$(GIT_COMMIT)"'

# High level actions. --- {{{

all: dev check build test format

dev:
	cp -rf ./other/git/hooks/* ./.git/hooks/

up:
	$(DOCKER_COMPOSE_CMD) --file $(DOCKER_COMPOSE_FILE) up --detach

down:
	$(DOCKER_COMPOSE_CMD) --file $(DOCKER_COMPOSE_FILE) down --remove-orphans

run:
	$(DOCKER_COMPOSE_CMD) \
        --file $(DOCKER_COMPOSE_FILE) \
        run \
        --rm \
        one \
        $(DOCKER_RUN_CMD)

shell:

build:
	$(DOCKER_COMPOSE_CMD) --file $(DOCKER_COMPOSE_FILE) build $(DOCKER_BUILD_ARGS)

check:

test:
	DOCKER_RUN_CMD='bash -c '"'"'bash -xv ./other/tests/test.sh'"'" make run

format: format_yaml format_json format_c

format_yaml:
	find $(ROOT_DIR) \( -iname '*.yml' -o -iname '*.yaml' -o -iname '.yamlfmt' \) -type f -print0 | xargs -0 -n 100 -- yamlfmt

format_json:
	find . -iname '*.json' -print0 | parallel --null --max-args 1 -- 'python3 -m json.tool --sort-keys {} > /tmp/$(PROJECT)_{/}_ {}'

clean:
	rm ./bin/* || true

#  --- }}}

# C related. --- {{{

host_compile:
	$(CC) $(CFLAGS) \
        -o $(TARGET) \
        ./one/src/one.c

host_run:

format_c:
	indent -kr -i4 -nut -l80 ./one/src/one.c

release: host_test clean release_static_linked release_dynamically_linked

release_static_linked:
	TARGET='./bin/one_static' CFLAGS='-O3 -Bstatic' make host_compile

release_dynamically_linked:
	TARGET='./bin/one_dynamic' CFLAGS='-O3 -Bdynamic' make host_compile

#  --- }}}

# Test related. --- {{{

host_test: host_compile
	bash -xv ./other/tests/host/test.sh

#  --- }}}
