#!/bin/bash

set -x
# This script will refresh the 'content' 
# folder found in './docker/simple-test-opsmanager-k8s/'
# to use when building the image
# '.docker/simple-test-opsmanager-k8s/Dockerfile'
# with fresh MongoDB and MongoDB Ops Manager
# build archives and the files in the 'src/'
# folder.
#
#

#Setup docker image name and tag
IMG_NAME="simple-test-opsmanager-k8s"
IMG_TAG="${IMG_NAME}:beta"

META_BUILD="./docker/${IMG_NAME}/content/build_info.log"
echo "${IMG_NAME} build-image automated build started $(date)" > ${META_BUILD}

for file in src/*; do
  rm "./docker/${IMG_NAME}/content/$(basename ${file})"
done

cp ./src/*.* ./docker/${IMG_NAME}/content/


echo "simple-test-opsmanager-k8s build-image automated build\
content-only update complete: $(date)" >> ${META_BUILD}

echo "Starting docker build of docker/${IMG_NAME} \
tag=${IMG_TAG}"
docker build docker/${IMG_NAME}\
 -t ${IMG_TAG}\
 -f docker/${IMG_NAME}/Dockerfile

echo "Build complete."
echo "Be sure \"image: ${IMG_TAG}\" reference is correct \
in any k8s yaml files"
