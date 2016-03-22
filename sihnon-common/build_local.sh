#!/bin/bash

env SKIP_SYNC=1 EMERGE_DEFAULTS_ARGS="-tv" SKIP_PORTAGE_SYNC=1 EQUO_MIRRORSORT=0 PORTDIR_OVERLAY=./local_overlay/ /vagrant/scripts/builder $(bash -c 'eval $(cat ./build.sh | egrep -v "^#|^\.|^build_all"); echo "${BUILD_ARGS[@]}";')

