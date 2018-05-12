#!/usr/bin/env bash
set -x
#
# mongod-launcher.sh
# This script fires up a demo a standalone MongoDB
# instance for the mms app db.
# For testing and demos only!
#
#
# Expects
# MONGODB_PORT
[[ -z "${MONGODB_PORT}" ]] && MONGODB_PORT=27017

# Configure mongodb instance
INSTALL_DIR="/mongodb-mms"
STARTUP_LOG="${INSTALL_DIR}/startup-mongod.log"
echo "mongod-launcher.sh STARTUP $(date)" > ${STARTUP_LOG}
MONGOD_BIN="${INSTALL_DIR}/mongodb/bin"
DBPATH="/mongodb-opsmgr-appdb/data"
rm -rf "${DBPATH}"
mkdir -p ${DBPATH}
LOCK="${DBPATH}/mongodb.lock"
SHELL="${MONGOD_BIN}/mongo --port=${MONGODB_PORT}"

# if lock stop
if [ ! -f ${LOCK} ]; then
    echo "Found ${LOCK}. Attempting mongod shutdown" >> ${STARTUP_LOG}
    echo "mongodb running, shutting down..." >> ${STARTUP_LOG}
    ${SHELL} admin --eval 'db.shutdownServer()'
    sleep 2
    rm ${LOCK}
    echo "mongod shutdown complete $(date)" >> ${STARTUP_LOG}
fi


# Fire up mongodb

echo "Starting ${MONGOD_BIN}/mongod --dbpath=${DBPATH} --port=${MONGODB_PORT}" >> ${STARTUP_LOG}
${MONGOD_BIN}/mongod --dbpath=${DBPATH} \
                     --port=${MONGODB_PORT} \
                     --logpath=${DBPATH}/mongodb.log \
                     --wiredTigerCacheSizeGB=2 \
                     --bind_ip_all \
                     --fork
echo "Started ${MONGOD_BIN}/mongod --dbpath=${DBPATH}" >> ${STARTUP_LOG}
head -20 ${MONGOD_BIN}/mongodb.log >> ${STARTUP_LOG}}

cat ${STARTUP_LOG}
echo "-- Reading ${DBPATH}/mongodb.log file forever" >> ${STARTUP_LOG}
# todo seems this doesn't work correctly and isn't streamed to supervisor output
tail -f ${DBPATH}/mongodb.log
