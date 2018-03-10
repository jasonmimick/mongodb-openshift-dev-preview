mongodb-openshift-dev-preview
=============================

```diff
+ STATUS: Work In Progress...
- STATUS: Did not exist
```

This is the MongoDB Enterprise Openshift "Developer Preview"!

The contents of this repository demonstrate functional integration
between the Red Hat Openshift PaaS and MongoDB Enterprise.
You can now spin up MongoDB Enterprise replica sets within
your own OpenShift environment with the click of
a button.

<span style='color:red'>**DISCLAIMER**:</span> This repository is for demonstration purposes only.
No assumptions should be made between this particular implementation
and future supported products from MongoDB, Inc. Do not use this in
anything close to a production environment. All support, as it is, takes
a standard open-source model. Anyone interested can contribute
through GitHub.

* [Introduction](#intro)

* [Getting Started](#gs)

* [Dependencies](#depends)

* [Development Environment Tips](#devenvtips)
* [Known Issues & Limitations](#issues)

<!--* [Technical Details](#td) -->

* [Contacts](#contact)

Introduction <a id="intro"></a>
------------

This repository contains artifacts which allow you to provision
MongoDB replica sets and agents-only pods into OpenShift. It
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

OpenShift specific, we use the new(er)
[Ansible Service Broker](https://github.com/openshift/ansible-service-broker)
available in OpenShift v3.7+. This broker registered services
to a central Service Catalog. The services are packaged as
Ansible Playbook Bundles](https://github.com/ansibleplaybookbundle).
 These artifacts constitute the majority
of the files in this repository.

<span style='color:red'>**_NOTE!_**</span> Being a new, 'prototype' project there are a number of detailed
steps required in order to use this functionality. Please be sure to
read this entire README _before_ attempting to get started.
Patience, young jedi, we call 'em README's for a reason.

Getting Started <a id="gs"></a>
-------------------------------

### Prerequisites

1. A working MongoDB Ops Manager installation. See
[Ops Manager setup](#om-setup) for additional configuration steps.

2. A working OpenShift environment, with the Ansible Service Broker.
A greate place to find info on building your development
environment is in the [APB Getting Started](https://github.com/ansibleplaybookbundle/ansible-playbook-bundle/blob/master/docs/getting_started.md).

Please see the [Dependencies](#depends) section for
details on specific versions of software used.

Consult the [Development Environement](#devenvtips)
section for tips on setting up your own
development environment.
3. Clone this repo

```
$git clone https://github.com/jasonmimick/mongodb-openshift-dev-preview
```

### Installing & Running the APB

We typically used these commands to test
the mongodb-enterprise apb. For some reason,
we needed to run the `apb push` command multiple
times in order for it to appear in the
OpenShift web-console.

```
apb build && apb push && apb push --push-to-broker
apb run --project default --action provision
```

The `apb run` command is an interactive command
in which you will be prompted to enter the
various configuration parameters.

#### Troubleshooting

* You can check the apb loaded correctly by running,
`apb list`. Make sure it appears. Also to validate
the service has been picked up by the lower
level ServiceCatalog, run

```
 oc get clusterserviceclasses -o=custom-columns=SERVICE\ NAME:.metadata.name,EXTERNAL\ NAME:.spec.externalName,TS:.metadata.creationTimestamp | grep mongo
 ```

 (The above produces a decently human readable output.) Be sure to check the timestamp. By default
 the ansible-service-broker only updates the
 ServiceCatalog every 15 mins. You can change
 this behavior, consult the `relistDuration`
 attribute.

To check:
 ```
 oc get clusterservicebrokers ansible-service-broker -o yaml
 ```

 To edit:
 ```
 oc edit clusterservicebroker ansible-service-broker
 ```

Dependencies<a id="depends"></a>
--------------------------------

* OpenShift 3.7+ with
`--service-catalog=true`
  * `oc` cli
* MongoDB Ops Manager 3.6+
* [apb](https://github.com/ansibleplaybookbundle/ansible-playbook-bundle) cli
* Docker Version 17.09.0-ce-mac35 (19611)
    * Some issue with very latest version for Mac


Development Environment Tips<a id="devenvtips"></a>
---------------------------------------------------


*Note:* All development was done on MacOS

Here's a sample script to bootstrap your
local OpenShift environment:

```
#!/bin/bash

oc --loglevel 3 cluster up --service-catalog=true
# run_latest_build.sh comes from the APB repo
./run_latest_build.sh
oc login --insecure-skip-tls-verify -u admin -p admin

oc login -u system:admin
oc adm policy add-scc-to-user anyuid -z default
oc adm policy add-scc-to-group anyuid system:authenticated
oc adm policy add-cluster-role-to-user cluster-admin developer
oc adm policy add-cluster-role-to-user cluster-admin admin

oc login -u developer -p developer
OPENSHIFT_TOKEN=$(oc whoami -t)
docker login -u developer -p ${OPENSHIFT_TOKEN} 172.30.1.1:5000
```

### Ops Manager Setup<a id="om-set"></a>

* Enable
[Public API access](https://docs.opsmanager.mongodb.com/current/tutorial/configure-public-api-access/)
for your account
  * Create an API key
  * Add appropriate ips or `0.0.0.0/0` to the IP Whitelist

Known Issues & Limitations<a id="issues"></a>
---------------------------------------------

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

* Need to build `action` to bind applications to

* TODO: Build sample app, e.g. simple web-app which reads/writes
data to bound mongodb cluster.


Contacts <a id="contact"></a>
--------

For technical questions, issues, sales and marketting support,
or just comments please email
[jason.mimick@mongodb.com](mailto://jason.mimick@mongodb.com) and
[dana.groce@mongodb.com](mailto://dana.groce@mongodb.com).

---------
This software is not supported by [MongoDB, Inc.](http://mongodb.com)
under any of their commercial support subscriptions or otherwise.
Any usage of the mongodb-openshift-dev-preview is at your own risk.
Bug reports, feature requests and questions can be posted in the 
[Issues](/issues?state=open) section on GitHub.
