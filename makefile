# Set variables.
SHELL := /bin/bash
ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

export PROJECT_NAME ?= $(notdir $(ROOT_DIR))

# Find all scala files.
SBT_FILES := $(shell find $(PROJECT_NAME) -iname 'build.sbt')
SCALA_FILES := $(shell find $(PROJECT_NAME) -iname '*.scala')
CONF_FILES := $(shell find $(PROJECT_NAME) -iname '*.conf')

SBT_VERSION := $(shell grep --fixed-strings 'sbt.version' -- $(PROJECT_NAME)/project/build.properties | sed -E 's/.*=//g')
SCALA_VERSION := 2.13.4

SCALA_NATIVE_BINARY := ./one/target/one

export _JAVA_OPTIONS ?= -Xms2048m -Xmx4096m

all: $(SCALA_NATIVE_BINARY) test format clean

print_target:
	@test -f $(shell readlink -f $(SCALA_NATIVE_BINARY))
	@printf $(shell readlink -f $(SCALA_NATIVE_BINARY))

format:
	scalafmt --config ./$(PROJECT_NAME)/.scalafmt.conf $(SCALA_FILES) $(SBT_FILES)
	cd ./$(PROJECT_NAME) \
        && sed -E 's/ /;scalafixAll /g' <<<'"dependency:fix.scala213.ConstructorProcedureSyntax@com.sandinh:scala-rewrites:0.1.10-sd" "dependency:fix.scala213.ParensAroundLambda@com.sandinh:scala-rewrites:0.1.10-sd" "dependency:fix.scala213.NullaryOverride@com.sandinh:scala-rewrites:0.1.10-sd" "dependency:fix.scala213.MultiArgInfix@com.sandinh:scala-rewrites:0.1.10-sd" "dependency:fix.scala213.Any2StringAdd@com.sandinh:scala-rewrites:0.1.10-sd" "dependency:fix.scala213.ExplicitNonNullaryApply@com.sandinh:scala-rewrites:0.1.10-sd" "dependency:fix.scala213.ExplicitNullaryEtaExpansion@com.sandinh:scala-rewrites:0.1.10-sd"' \
            | sed -E 's/^/scalafixAll /g' \
            | xargs --verbose -I % -0 -- sbt '++2.13.3;project crossProjJVM;%'

clean:
	find . -iname 'target' -print0 | xargs -0 rm -rf
	find . -path '*/project/*' -type d -prune -print0 | xargs -0 rm -rf
	find . -iname '*.class' -print0 | xargs -0 rm -rf
	find . -iname '.bsp' -print0 | xargs -0 rm -rf
	find . -iname '.metals' -print0 | xargs -0 rm -rf
	find . -iname '.bloop' -print0 | xargs -0 rm -rf
	find . -iname '*.hnir' -print0 | xargs -0 rm -rf
	find . -type d -empty -delete

test: host_test

host_test: host_test_sbt host_test_bash

host_test_sbt:
	cd ./$(PROJECT_NAME) \
        && sbt '+ test'

host_test_bash: $(SCALA_NATIVE_BINARY)
	bash -xv ./other/test/bash/test.sh

nativelink: $(SCALA_NATIVE_BINARY)

$(SCALA_NATIVE_BINARY): $(CONF_FILES) $(SCALA_FILES) $(SBT_FILES)
	cd ./$(PROJECT_NAME) \
        && sbt nativeLink

sbt:
	cd ./$(PROJECT_NAME) && sbt

# Docker actions. --- {{{

docker_build: scala_cli_parser
	docker build \
        --file ./dockerfile \
        --tag $(PROJECT_NAME) \
        --build-arg project_name=$(PROJECT_NAME) \
        --build-arg sbt_version=$(SBT_VERSION) \
        --build-arg scala_version=$(SCALA_VERSION) \
        -- . \
        1>&2

docker_run:
	docker run \
        --interactive \
        --rm \
        --tty \
        --entrypoint '' \
        $(PROJECT_NAME) \
        $(if $(DOCKER_CMD),$(DOCKER_CMD),bash)

docker_test: docker_build
	DOCKER_CMD='make host_test' make docker_run

# --- }}}

scala_cli_parser: tmp/scala_cli_parser/makefile

tmp/scala_cli_parser/makefile: .FORCE
	rm -rf $(dir $@)
	cp -rf $(shell get_project_path scala_cli_parser) $(dir $@)
	cd $(dir $@) && env --ignore-environment -- bash -l -c "make clean"

.FORCE:

# vim: set noexpandtab foldmethod=marker fileformat=unix filetype=make nowrap foldtext=foldtext():
