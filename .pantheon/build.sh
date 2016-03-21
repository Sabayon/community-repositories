#!/bin/bash
set -e

. /vagrant/scripts/functions.sh

export DOCKER_PULL_IMAGE="${DOCKER_PULL_IMAGE:-1}"
export EMERGE_DEFAULTS_ARGS="-k --accept-properties=-interactive --verbose --oneshot --complete-graph --buildpkg"
export REPOSITORY_DESCRIPTION="Pantheon Desktop Environment Community Repository"

BUILD_ARGS=(
  "pantheon-base/pantheon-shell"
  "--layman elementary"
  "--install x11-libs/gtk+:3"
  "--remove dev-libs/libdbusmenu"
)

build_all "${BUILD_ARGS[@]}"
