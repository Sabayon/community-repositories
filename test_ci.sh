#!/bin/bash

export VAGRANT_DIR="${VAGRANT_DIR:-$(pwd)/buildpspec}"
export DEVKIT_DIR="${VAGRANT_DIR:-$(pwd)/devkit}"

export COMMIT_RANGE="${1}"

# If given in a github form, it will be extracted commit range
if [[ $COMMIT_RANGE == *https://* ]]; then
  echo "Extracting commit range"
  COMMIT_RANGE=$(echo $COMMIT_RANGE | rev | cut -d / -f 1 | rev)
fi

COMMIT_RANGE=${COMMIT_RANGE/.../..}
echo "Range: $COMMIT_RANGE"

SPECFILE=($(git diff-tree --name-status -r --no-commit-id ${COMMIT_RANGE} | awk "{print \$2 }" | grep build.yaml)) #Get build.yaml changed

# install required deps
pip install shyaml

[ -e ${DEVKIT_DIR} ] && rm -rf ${DEVKIT_DIR}

git clone https://github.com/Sabayon/devkit.git ${DEVKIT_DIR}

pushd ${DEVKIT_DIR}

  make
  make install

popd

[ -d ${VAGRANT_DIR} ] && rm -rf ${VAGRANT_DIR}

git clone https://github.com/Sabayon/community-buildspec.git ${VAGRANT_DIR}

. ${VAGRANT_DIR}/scripts/functions.sh

#cd ${VAGRANT_DIR}
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "Will be built:"
for i in "${SPECFILE[@]}"
do
   :
   echo " ----> ${i}"
 done


echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
for i in "${SPECFILE[@]}"
do
   :
    echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
    echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
    echo "Building ${i}"
    echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
    echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"

    load_env_from_yaml $i

    # Speed up test runs by disabling slow syncs and mirror sorts
    export SKIP_PORTAGE_SYNC="${SKIP_PORTAGE_SYNC:-1}"
    export EQUO_MIRRORSORT="${EQUO_MIRRORSORT:-0}"

    # Debug what env vars are being passed to the builder
    printenv | sort

    build_all ${BUILD_ARGS}

    # do whatever on $i
done
