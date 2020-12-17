# Set variables.
SHELL := /bin/bash
ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

export PROJECT_NAME ?= $(notdir $(ROOT_DIR))
export _JAVA_OPTIONS := -Xms2048m -Xmx4096m

FINAL_TARGET := ./one/target/scala-2.11/one

# Increase the `ulimit` to avoid: "java.nio.file.ClosedFileSystemException".
$(shell ulimit -HSn 10000)

all: nativelink test

clean:
	find . -iname 'target' -print0 | xargs -0 rm -rf
	find . -path '*/project/*' -type d -prune -print0 | xargs -0 rm -rf
	find . -iname '*.class' -print0 | xargs -0 rm -rf
	find . -iname '*.hnir' -print0 | xargs -0 rm -rf
	find . -type d -empty -delete

# Test actions. --- {{{

test: test_scala test_bash

test_bash: $(FINAL_TARGET)

test_scala:
	cd $(PROJECT_NAME) && sbt 'test'

# ???: This tasks fails erratically but succeeds after a few retries.
nativelink:
	cd $(PROJECT_NAME) && sbt 'nativeLink'

compile: $(SBT_FILES) $(SCALA_FILES)
	cd $(PROJECT_NAME) && sbt 'compile'

# --- }}}

$(FINAL_TARGET): nativelink

# Docker actions. --- {{{

docker_build:
	docker build \
        --file ./dockerfile \
        --tag $(PROJECT_NAME) \
        --build-arg project_name=$(PROJECT_NAME) \
        -- . \
        1>&2

docker_run:
	docker run \
        --interactive \
        --tty \
        --entrypoint '' \
        $(PROJECT_NAME) \
        $(if $(DOCKER_CMD),$(DOCKER_CMD),bash)

docker_test:
	DOCKER_CMD='make test' make docker_run
	DOCKER_CMD='make nativelink' make docker_run

# --- }}}

.FORCE:

# .EXPORT_ALL_VARIABLES:

.PHONY: all clean test doc test_sbt test_bash

# vim: set noexpandtab foldmethod=marker fileformat=unix filetype=make nowrap foldtext=foldtext():
