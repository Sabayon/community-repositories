#!/bin/bash

if [ ! -e /vagrant/scripts/functions.sh ]; then
    echo "Must be run from within the community-buildspec vagrant box"
    exit 1
fi

. /vagrant/scripts/functions.sh

if [ ! -e build.yaml ]; then
    echo "Must be run from a repository directory containing a build.yaml"
    exit 1
fi

load_env_from_yaml build.yaml

# Speed up test runs by disabling slow syncs and mirror sorts
export SKIP_PORTAGE_SYNC=1
export EQUO_MIRRORSORT=0

# Debug what env vars are being passed to the builder
printenv | sort

build_all ${BUILD_ARGS}
