#!/bin/bash

export VAGRANT_DIR="${VAGRANT_DIR:-$(pwd)/buildspec}"
export DEVKIT_DIR="${DEVKIT_DIR:-$(pwd)/devkit}"
export DOCKER_COMMIT_IMAGE=${DOCKER_COMMIT_IMAGE:-false}
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

if [ -d ${DEVKIT_DIR} ]; then
  pushd ${DEVKIT_DIR}
  git fetch --all
  git reset --hard origin/master
  popd
else
  git clone https://github.com/Sabayon/devkit.git ${DEVKIT_DIR} || exit 1
fi

pushd ${DEVKIT_DIR}

  make
  make install

popd

if [ -d ${VAGRANT_DIR} ]; then
  pushd ${VAGRANT_DIR}
  git fetch --all
  git reset --hard origin/master
  popd
else
  git clone https://github.com/Sabayon/community-buildspec.git ${VAGRANT_DIR} || exit 1
fi

. ${VAGRANT_DIR}/scripts/functions.sh

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

    # Debug what env vars are being passed to the builder
    printenv | sort

    build_all ${BUILD_ARGS}
done
