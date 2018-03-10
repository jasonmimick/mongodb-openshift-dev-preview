mongodb-openshift-dev-preview
=============================

This is the MongoDB Enterprise Openshift "Developer Preview"!
The contents of this repository demonstrate functional integration
between the Red Hat Openshift PaaS and MongoDB Enterprise.
You can now spin up MongoDB Enterprise replica sets within
your own OpenShift environment.

**DISCLAIMER**: This repository is for demonstration purposes only.
No assumptions should be made between this particular implementation
and future supported products from MongoDB, Inc. Do not use this in
anything close to a production environment. All support, as it is, takes
a standard open-source model. Anyone interested can contribute
through GitHub.

* [Introduction](#intro)

* [Getting Started](#gs)

* [Known Issues & Limitations](#issues)

<!--* [Technical Details](#td) -->

* [Contacts](#contact)

Introduction <a id="intro"></a>
------------

This repository contains artifacts which allow you to provision
MongoDB replica sets and agents-only instances into OpenShift. It
leverages
[MongoDB Ops Manager](https://www.mongodb.com/products/ops-manager)
for automation, monitoring, alerting, and backup functionality.
The basic design uses OpenShift to provision pods (with 1
container each running an instance of an automation agent)
and then invokes REST API calls to MongoDB Ops Manager which,
in turn, installs MongoDB instances into each pod.

Being a "developer preview" these artifacts can be treated as a
"functional prototype". Here we mean, this demonstrates
functionally how future MongoDB-supported product(s) will
operate. The actual implementation of any such future product(s)
is yet to be determined.

OpenShift specfic, we use the new(er)
[Ansible Service Broker](https://github.com/openshift/ansible-service-broker)
available in OpenShift v3.7+. This broker registered services
to a central Service Catalog. The services are packaged as
Ansible Playbook Bundles](https://github.com/ansibleplaybookbundle).
 These artifacts consitute the majority
of the files in this repository.


Getting Started <a id="gs"></a>
---------------

### Prerequisites

1. A working MongoDB Ops Manager installation. See
[Ops Manager setup](#om-setup) for additional configuration steps.

2. A working OpenShift environment, with the Ansible Service Broker.
A greate place to find info on building your development
environment is in the [APB Getting Started](https://github.com/ansibleplaybookbundle/ansible-playbook-bundle/blob/master/docs/getting_started.md).

3. Clone this repo

```
$git clone https://github.com/jasonmimick/mongodb-openshift-dev-preview
```

### Installing the APB

apb push
apb push --push-to-broker

cli

run-apb.sh helper

ui

### Provisioning MongoDB

Known Issues & Limitations<a id="issues"></a>

List of issues, Limitations, and to-dos. These should become "issues"
as needed.

* MongoDB processes have startup warning because
  * XFS filesystem isn't provisioned on persistent volumes
  * Database authentication is not enabled
* Sharded cluster deployments are yet supported (but possible by
manually deploying *agent-only* nodes).
* Deprovision not functional yet. Manually clean things, e.g.


```
oc get dc | grep mongodb-server | cut -f1 -d' ' |\
 xargs oc delete dc --force=true
oc get pvc | grep mongo-cluster | cut -f1 -d' ' |\
 xargs oc delete pvc --force=true
oc get statefulset | grep mongodb-server | cut -f1 -d' ' |\
 xargs oc delete statefulset --force=true
oc get svc | grep mongodb-service-cluster | cut -f1 -d' ' |\
 xargs oc delete svc --force=true
oc get pods | grep apb-run-provision-mongodb | cut -f1 -d' ' |\
 xargs oc delete pod --force=true
```

and to delete a bunch of old projects in MongoDB Ops Manager:

```
USER=$1
APIKEY=$2

curl -S --header "Accept: application/json" \
 -vvv \
 --user "${USER}:${APIKEY}" \
 --digest \
 "http://localhost:8080/api/public/v1.0/groups" |\
 jq -r ".results[].links[].href" |\
 xargs curl --header "Accept: application/json" \
 -vvv \
 --user "${USER}:${APIKEY}" \
 --digest \
 --include \
 --request DELETE
```

* `install-automation-agent.sh` script is downloaded from Github.
This requires internet access for pods. Should bundle agent with
Docker image or somehow.



Contacts <a id="contact"></a>
--------

For technical questions, issues, sales and marketting support,
or just comments please email
[jason.mimick@mongodb.com](mailto://jason.mimick@mongodb.com) and
[dana.groce@mongodb.com](mailto://dana.groce@mongodb.com).
