#!/bin/bash

export VAGRANT_DIR="${VAGRANT_DIR:-$(pwd)/buildpspec}"
export DEVKIT_DIR="${VAGRANT_DIR:-$(pwd)/devkit}"

SPECFILE=$(git diff-tree --name-status -r --no-commit-id ${1} | awk "{print \$2 }")

echo "Building ${SPECFILE}"

pip install shyaml

[ -e ${DEVKIT_DIR} ] && rm -rf ${DEVKIT_DIR}

git clone git@github.com:Sabayon/devkit.git ${DEVKIT_DIR}

pushd ${DEVKIT_DIR}

  make
  make install

popd

[ -d ${VAGRANT_DIR} ] && rm -rf ${VAGRANT_DIR}

git clone git@github.com:Sabayon/community-buildspec.git ${VAGRANT_DIR}

. ${VAGRANT_DIR}/scripts/functions.sh

#cd ${VAGRANT_DIR}

if [ ! -e "$SPECFILE" ]; then
    echo "You must specify a specfile!"
    exit 1
fi

load_env_from_yaml ${SPECFILE}

# Speed up test runs by disabling slow syncs and mirror sorts
export SKIP_PORTAGE_SYNC="${SKIP_PORTAGE_SYNC:-1}"
export EQUO_MIRRORSORT="${EQUO_MIRRORSORT:-0}"

# Debug what env vars are being passed to the builder
printenv | sort

build_all ${BUILD_ARGS}
