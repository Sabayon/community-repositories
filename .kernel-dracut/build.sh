#!/bin/bash
. /vagrant/scripts/functions.sh

export EMERGE_DEFAULTS_ARGS="-k --accept-properties=-interactive --verbose --oneshot --complete-graph --buildpkg"
export REPOSITORY_DESCRIPTION="Kernel with dracut testing Repository"

BUILD_ARGS=(
  "sys-kernel/linux-sabayon"
  "x11-drivers/nvidia-drivers::sabayon-distro"
  "x11-drivers/nvidia-drivers::sabayon-distro"
  "x11-drivers/xf86-video-virtualbox"
)
#    "x11-drivers/ati-drivers::sabayon-distro", leaving it behind for now. package download is restricted


build_all "${BUILD_ARGS[@]}"
