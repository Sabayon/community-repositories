#!/bin/bash

. /vagrant/scripts/functions.sh

export REPOSITORY_DESCRIPTION="Sihnon desktop packages"

BUILD_ARGS=(
    "app-crypt/yubico-piv-tool"
    "app-crypt/yubikey-neo-manager"
    "app-crypt/yubikey-piv-manager"
    "sys-auth/ykpers"
    "--layman jkolo"
)

build_all "${BUILD_ARGS[@]}"
