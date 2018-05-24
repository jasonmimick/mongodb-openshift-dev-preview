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

#Find urls to download MongoDB and Ops Manager bits
MMS_REPO="${1:-/Users/jmimick/work/mms/.git}"
MMS_BUILD_LINK_FILE="${2:-./.latest-mms-build-url}"
./get-latest-mms.sh "${MMS_REPO}" "${MMS_BUILD_LINK_FILE}"
X=$(cat ${MMS_BUILD_LINK_FILE})
#X=$(curl -s https://s3.amazonaws.com/mongodb-mms-build-onprem/ops_manager_beta.html |\
# grep "^<tr><td>" |\
# grep ".tar.gz" |\
# sed -e 's:<tr><td>::g' -e 's:</a></td><tr>::g' -e 's:<a href="::g'|\
# cut -d"\"" -f1)


Y=$(curl -s https://www.mongodb.org/dl/linux/x86_64-debian81 |\
 grep "debian81-3.7" | head -1 |\
 cut -d'>' -f2 | sed -e 's:<a href="::g' -e 's:"::g')

# If you have issue with the above dynamic downloading & parsing of the urls
# bash above, then you have just download archives for mongodb and mms
# and set the variables right here.
# TODO: add command linem parameter to pass this in or perhaps a 
# --download type flag
#Y="file:///Users/jmimick/Downloads/mongodb-linux-x86_64-debian71-3.6.4.tgz"
#X="file:///Users/jmimick/Downloads/mongodb-mms-3.7.0.622-1.x86_64.tar.gz"

MONGODB_URL=$Y
MMS_URL=$X


echo "MONGODB_URL=${MONGODB_URL}"
echo "MMS_URL=${MMS_URL}"

echo "Simple Test OpsManager K8S: Starting build"
echo "Docker image name: '${IMG_NAME}'"
echo "Docker image tag: '${IMG_TAG}'"

echo "Attempting download of ${MONGODB_URL} and ${MMS_URL}"
TEMP_DIR=$(mktemp -d)
echo "Downloading into ${TEMP_DIR}"

curl -o ${TEMP_DIR}/mongodb.tar.gz ${MONGODB_URL}
curl -o ${TEMP_DIR}/mongodb-mms.tar.gz ${MMS_URL}

rm -rf ./docker/${IMG_NAME}/content
mkdir -p ./docker/${IMG_NAME}/content

# Next log is to store meta-data into image as to when it was built
META_BUILD="./docker/${IMG_NAME}/content/build_info.log"
echo "${IMG_NAME} build-image automated build started $(date)" > ${META_BUILD}
echo "Downloaded ${MONGODB_URL}" >> ${META_BUILD}
echo "Download ${MMS_URL}" >> ${META_BUILD}

mkdir -p ./docker/${IMG_NAME}/content/mongodb
mkdir -p ./docker/${IMG_NAME}/content/mongodb-mms


tar xzvf ${TEMP_DIR}/mongodb.tar.gz \
-C ./docker/${IMG_NAME}/content/mongodb \
--strip-components=1
tar xzvf ${TEMP_DIR}/mongodb-mms.tar.gz \
-C ./docker/${IMG_NAME}/content/mongodb-mms \
--strip-components=1

cp ./src/*.* ./docker/${IMG_NAME}/content/
rm -rf "${TEMP_DIR}"

echo "simple-test-opsmanager-k8s build-image automated build\
conent update complete: $(date)" >> ${META_BUILD}

echo "Starting docker build of docker/${IMG_NAME} \
tag=${IMG_TAG}"
docker build docker/${IMG_NAME}\
 -t ${IMG_TAG}\
 -f docker/${IMG_NAME}/Dockerfile

echo "Build complete."
echo "Be sure \"image: ${IMG_TAG}\" reference is correct \
in any k8s yaml files"
