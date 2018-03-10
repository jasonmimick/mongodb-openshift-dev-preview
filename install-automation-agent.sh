#!/bin/bash
# Expects $MMS_GROUP_ID and $MMS_AGENT_APIKEY
# MMS_USER, and MMS_APIKEY

#TODO: Error if environment varibles not set.

AGENT_URL=${MMS_BASE_URL_INTERNAL}/download/agent/automation/
AGENT=mongodb-mms-automation-agent-manager-

# TODO - How to discover this download???? can't find in api
#AGENT_VERSION=3.2.14.2187-1.x86_64.rhel7.rpm
AGENT_VERSION=4.5.11.2453-1.x86_64.rhel7.rpm
# We need to auto-detect the automation agent versions
# available for us to download

echo "Downloading $AGENT_URL$AGENT$AGENT_VERSION"
curl -OL "$AGENT_URL$AGENT$AGENT_VERSION"

echo "Installing $AGENT$AGENT_VERSION"
rpm -U $AGENT$AGENT_VERSION
echo "Updating /etc/mongodb-mms/automation-agent.config with:"
echo "mmsGroupId=${MMS_GROUP_ID}"
echo "mmsApiKey=${MMS_AGENT_APIKEY}"
echo "mmsBaseUrl=${MMS_BASE_URL_INTERNAL}"
cat << ENDMMS >> /etc/mongodb-mms/automation-agent.config

# ############################################
# mms-k8s MongoDB Ops Manager Kubernetes StatefulSet Generator
# Automatically updated on: `date`
#
# DO NOT EDIT!
#
# See: https://github.com/jasonmimick/k8s-mongodb-opsmanager
# ############################################
mmsGroupId=${MMS_GROUP_ID}
mmsApiKey=${MMS_AGENT_APIKEY}
mmsBaseUrl=${MMS_BASE_URL_INTERNAL}
ENDMMS

chown mongod:mongod /data

echo "Creating /var/run/mongodb-mms-automation"
/usr/bin/mkdir -p /var/run/mongodb-mms-automation
/usr/bin/chown -R mongod:mongod /var/run/mongodb-mms-automation
echo "Starting automation agent..."
su -s "/bin/bash" -c "/opt/mongodb-mms-automation/bin/mongodb-mms-automation-agent \
-f /etc/mongodb-mms/automation-agent.config \
-pidfilepath /var/run/mongodb-mms-automation/mongodb-mms-automation-agent.pid" mongod
echo "MongoDB Ops Manager automation agent stopped at `date`."


