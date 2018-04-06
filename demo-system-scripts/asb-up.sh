#!/bin/bash
#
# Logging in as system:admin so we can create a clusterrolebinding and
# creating ansible-service-broker project
#
echo 'Logging in as "system:admin" to create broker resources...'
oc login -u system:admin
oc new-project ansible-service-broker

#
# A valid dockerhub username/password is required so the broker may
# authenticate with dockerhub to:
#
#  1) inspect the available repositories in an organization
#  2) read the manifest of each repository to determine metadata about
#     the images
#
# This is how the Ansible Service Broker determines what content to
# expose to the Service Catalog
#
# Note:  dockerhub API requirements require an authenticated user only,
# the user does not need any special access beyond read access to the
# organization.
#
# By default, the Ansible Service Broker will look at the
# 'ansibleplaybookbundle' organization, this can be overridden with the
# parameter DOCKERHUB_ORG being passed into the template.
#
TEMPLATE_URL=${TEMPLATE_URL:-"https://raw.githubusercontent.com/openshift/ansible-service-broker/master/templates/deploy-ansible-service-broker.template.yaml"}
DOCKERHUB_ORG=${DOCKERHUB_ORG:-"ansibleplaybookbundle"} # DocherHub org where APBs can be found, default 'ansibleplaybookbundle'
ENABLE_BASIC_AUTH="false"
VARS="-p BROKER_CA_CERT=$(oc get secret -n kube-service-catalog -o go-template='{{ range .items }}{{ if eq .type "kubernetes.io/service-account-token" }}{{ index .data "service-ca.crt" }}{{end}}{{"\n"}}{{end}}' | tail -n 1)"

curl -s $TEMPLATE_URL \
  | oc process \
  -n ansible-service-broker \
  -p DOCKERHUB_ORG="$DOCKERHUB_ORG" \
  -p ENABLE_BASIC_AUTH="$ENABLE_BASIC_AUTH" \
  -p NAMESPACE=ansible-service-broker \
  $VARS -f - | oc create -f -
if [ "$?" -ne 0 ]; then
  echo "Error processing template and creating deployment"
  exit
fi

#
# Then login as 'developer'/'developer' to WebUI
# Create a project
# Deploy mediawiki to new project (use a password other than
#   admin since mediawiki forbids admin as password)
# Deploy PostgreSQL(ABP) to new project
# After they are up
# Click 'Create Binding' on the kebab menu for Mediawiki,
#   select postgres
# Click deploy on mediawiki, after it's redeployed access webui
#

echo 'NOTE: You are currently logged in as "system:admin", if you intend to use the apb tool, is is required you log in as a user with a token. "developer" is recommended.'
echo '    oc adm policy add-cluster-role-to-user cluster-admin developer'
echo '    oc login -u developer'

