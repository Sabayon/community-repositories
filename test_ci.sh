#!/bin/bash

export VAGRANT_DIR="${VAGRANT_DIR:-$(pwd)/buildspec}"
export DEVKIT_DIR="${DEVKIT_DIR:-$(pwd)/devkit}"
export SARK_DIR="${SARK_DIR:-$(pwd)/sark}"
export PRETEND=1
export QA_CHECKS=1
export DOCKER_COMMIT_IMAGE=${DOCKER_COMMIT_IMAGE:-false}
export COMMIT_RANGE="${1}"

# If given in a github form, it will be extracted commit range
if [[ $COMMIT_RANGE == *https://* ]]; then
  echo "Extracting commit range"
  COMMIT_RANGE=$(echo $COMMIT_RANGE | rev | cut -d / -f 1 | rev)
fi

COMMIT_RANGE=${COMMIT_RANGE/.../..}
echo "Range: $COMMIT_RANGE"

SPECFILE=($(git diff-tree --name-status -r --no-commit-id ${COMMIT_RANGE} | awk "{print \$2 }")) #Get build.yaml changed

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

if [ -d ${SARK_DIR} ]; then
  pushd ${SARK_DIR}
  git fetch --all
  git reset --hard origin/master
  popd
else
  git clone https://github.com/Sabayon/sabayon-sark ${SARK_DIR} || exit 1
fi

pushd ${SARK_DIR}

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

. /sbin/sark-functions.sh

echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "Changed files:"
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

    IFS='/' read -r -a repo_name <<< "$i"
    export REPOSITORY_NAME=${repo_name[0]}

    echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
    echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
    echo "[${REPOSITORY_NAME}]: ${i}"
    echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
    echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
    if [ -e "$REPOSITORY_NAME/build.yaml" ]; then
      pushd "$REPOSITORY_NAME"
      load_env_from_yaml build.yaml

      # Debug what env vars are being passed to the builder
      printenv | sort

      build_all ${BUILD_ARGS}
      popd
    fi
done
