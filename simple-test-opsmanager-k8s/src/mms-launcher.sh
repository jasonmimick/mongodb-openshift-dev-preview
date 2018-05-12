#!/usr/bin/env bash
set -x
#
# mms-launcher.sh
# This script fires up a demo testing only!
# instance of Ops Manager with NO backup daemon
#
# Expects following env vars
#GLOBAL_ADMIN_EMAIL="admin@example.com"
#GLOBAL_ADMIN_PWD="mongodb123!"
#OPSMGR_UI_PORT="8080"
#OPSMGR_PROJECT_NAME="k8s-project-0"
#OPSMGR_APPDB="mongodb://xxxx"

[[ -z "${GLOBAL_ADMIN_EMAIL}" ]] && GLOBAL_ADMIN_EMAIL="admin@example.com"
[[ -z "${GLOBAL_ADMIN_PWD}" ]] && GLOBAL_ADMIN_PWD="mongodb123!"
[[ -z "${OPSMGR_UI_PORT}" ]] && OPSMGR_UI_PORT=8080
[[ -z "${OPSMGR_PROJECT_NAME}" ]] && OPSMGR_PROJECT_NAME="k8s-project-0"
[[ -z "${OPSMGR_APPDB}" ]] && OPSMGR_APPDB="mongodb://mongodb-opsmgr-appdb:27017/?maxPoolSize=150"

# Configure mongodb instance
INSTALL_DIR="/mongodb-mms"
STARTUP_LOG="${INSTALL_DIR}/startup-mms.log"
echo "mms-launcher.sh STARTUP $(date)" > ${STARTUP_LOG}
MMS_BIN="${INSTALL_DIR}/mongodb-mms/bin"

# Configure mms instance

AUTOMATION_VERSIONS_DIRECTORY="/mongodb-mms/mongodb-releases"
mkdir "${AUTOMATION_VERSIONS_DIRECTORY}"
HOSTNAME=$(hostname -f)
MMS_EMAIL="opsmgr@example.com"
echo "Found hostname `${HOSTNAME}`" >> ${STARTUP_LOG}
cat <<CONF_MMS >> ${INSTALL_DIR}/mongodb-mms/conf/conf-mms.properties
# Generated om-on-k8s $(date)
mms.ignoreInitialUiSetup=true
mongo.mongoUri=${OPSMGR_APPDB}
mms.https.ClientCertificateMode=None
mms.centralUrl=http://${HOSTNAME}:${OPSMGR_UI_PORT}
mms.fromEmailAddr=${MMS_EMAIL}
mms.replyToEmailAddr=${MMS_EMAIL}
mms.adminEmailAddr=${MMS_EMAIL}
mms.emailDaoClass=com.xgen.svc.core.dao.email.JavaEmailDao
mms.mail.transport=smtp
mms.mail.hostname=localhost
mms.mail.port=25
automation.versions.directory=${AUTOMATION_VERSIONS_DIRECTORY}
CONF_MMS

echo "${INSTALL_DIR}/mongodb-mms/conf/conf-mms.properties updated" >> ${STARTUP_LOG}

if [ "${OPSMGR_UI_PORT}" != "8080" ]; then
   echo "Updating ${INSTALL_DIR}/mongodb-mms/conf/mms.conf with BASE_PORT=${OPSMNGR_UI_PORT}" >> ${STARTUP_LOG}
   grep -v "BASE_PORT=" ${INSTALL_DIR}/mongodb-mms/conf/mms.conf >\
   ${INSTALL_DIR}/mongodb-mms/conf/mms-port-update.conf
   echo "BASE_PORT=${OPSMGR_UI_PORT}" >> ${INSTALL_DIR}/mongodb-mms/conf/mms-port-update.conf
   mv ${INSTALL_DIR}/mongodb-mms/conf/mms-port-update.conf \
   ${INSTALL_DIR}/mongodb-mms/conf/mms.conf
fi
echo "Disabling automatic backup daemon start" >> ${STARTUP_LOG}
grep -v '"${APP_DIR}/bin/mongodb-mms-backup-daemon" start' \
${MMS_BIN}/mongodb-mms > ${MMS_BIN}/mongodb-mms-no-backup-daemon
MMS_BIN_SCRIPT="${MMS_BIN}/mongodb-mms-no-backup-daemon"
chmod +x "${MMS_BIN_SCRIPT}"
echo "Automatic backup daemon start disabled" >> ${STARTUP_LOG}
ls -l "${MMS_BIN}" >> ${STARTUP_LOG}

# Fire up mms
echo "Starting ${MMS_BIN_SCRIPT} start" >> ${STARTUP_LOG}
${MMS_BIN_SCRIPT} start
echo "Started ${MMS_BIN_SCRIPT} start" >> ${STARTUP_LOG}


OPSMGR_URL="http://${HOSTNAME}:${OPSMGR_UI_PORT}"
# need to wait until mms is really up before continuing
WAIT_SLEEP_SECONDS=10
echo "Waiting for mms to be available at '${OPSMGR_URL}' $(date)" >> ${STARTUP_LOG}
while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' ${OPSMGR_URL})" != "303" ]]; do
  sleep ${WAIT_SLEEP_SECONDS}
  echo "Still waiting... $(date)" >> ${STARTUP_LOG}
  curl -vvv ${OPSMGR_URL} >> ${STARTUP_LOG}
done
echo "mms was up at ${OPSMGR_URL} $(date)" >> ${STARTUP_LOG}

echo "GLOBAL_ADMIN_EMAIL=${GLOBAL_ADMIN_EMAIL}" >> ${STARTUP_LOG}
echo "GLOBAL_ADMIN_PWD=${GLOBAL_ADMIN_PWD}" >> ${STARTUP_LOG}
echo "OPSMGR_URL=${OPSMGR_URL}" >> ${STARTUP_LOG}
curl -vvv -H "Content-Type: application/json" -i \
-X POST "${OPSMGR_URL}/api/public/v1.0/unauth/users?whitelist=0.0.0.0/0" \
--data "{
   \"username\": \"${GLOBAL_ADMIN_EMAIL}\",
   \"emailAddress\": \"${GLOBAL_ADMIN_EMAIL}\",
   \"password\": \"${GLOBAL_ADMIN_PWD}\",
   \"firstName\": \"admin\",
   \"lastName\": \"admin\"
 }" | tail -n 1 > out1.json

APIKEY=`jq -r '.apiKey' out1.json`

cat out1.json >> ${STATUP_LOG}

echo "Created mms - user '${GLOBAL_ADMIN_EMAIL}'" >> ${STARTUP_LOG}
echo "user apikey = \"${APIKEY}\"" >> ${STARTUP_LOG}

echo "Creating group '${OPSMGR_PROJECT_NAME}'..." >> ${STARTUP_LOG}
curl -vvv -u "${GLOBAL_ADMIN_EMAIL}:${APIKEY}" \
-H "Content-Type: application/json" --digest -i -X POST \
"${OPSMGR_URL}/api/public/v1.0/groups" --data "{
  \"name\": \"${OPSMGR_PROJECT_NAME}\"
}"  | tail -n 1 > out2.json

GROUP_ID=$(jq -r '.id' out2.json)
ORG_ID=$(jq -r '.orgId' out2.json)

AGENT_APIKEY=$(jq -r '.agentApiKey' out2.json)$
head -30 out2.json >> ${STARTUP_LOG}

echo "GROUP '${OPSMGR_PROJECT_NAME}' GROUPID=${GROUPID} AGENT_APIKEY=${AGENT_APIKEY}" >> ${STARTUP_LOG}

# Generate ConfigMap for MongoDB Kubernetes Operator to use
# for this new Ops Manager deployment.
CONFIG_MAP="${INSTALL_DIR}/opsmgr-config-map.yaml"
cat <<CONFIG_MAP >> ${CONFIG_MAP}
apiVersion: v1
kind: ConfigMap
metadata:
  name: global-om-config
data:
  PUBLIC_API_KEY: ${APIKEY}
  GROUP_ID: ${GROUP_ID}
  BASE_URL: ${OPSMGR_URL}
  USER_LOGIN: ${GLOBAL_ADMIN_EMAIL}
  ORG_ID: ${ORG_ID}
  AGENT_APIKEY: ${AGENT_APIKEY}
CONFIG_MAP

echo "Wrote MongoDB Ops Manager Kubernetes Operator
cat ${STARTUP_LOG}


echo "-- Reading ${INSTALL_DIR}/mongodb-mms/logs/mms0.log file forever" >> ${STARTUP_LOG}
tail -f ${INSTALL_DIR}/mongodb-mms/logs/mms0.log
