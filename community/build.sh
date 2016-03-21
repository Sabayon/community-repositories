#!/bin/bash

. /vagrant/scripts/functions.sh

export REPOSITORY_DESCRIPTION="Community Repository"

BUILD_ARGS=(
  "app-text/cherrytree::and3k-sunrise"
  "games-strategy/megaglest::games-overlay"
  "app-emulation/shashlik-bin::anyc"
  "media-gfx/sweethome3d-bin::activehome"
  "--layman activehome"
  "--layman and3k-sunrise"
  "--layman anyc"
  "--layman games-overlay"
)

build_all "${BUILD_ARGS[@]}"
