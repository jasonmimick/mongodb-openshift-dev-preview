mongodb-openshift-dev-preview
=============================

```diff
+ STATUS: Work In Progress...
- STATUS: Did not exist
```

This is the MongoDB Enterprise Openshift "Developer Preview".

The contents of this repository demonstrate a functional integration
between the Red Hat OpenShift PaaS and MongoDB Enterprise.
You can now spin up MongoDB Enterprise replica sets within
your own OpenShift environment with the click of
a button.

<span style='color:red'>**WARNING!**</span> This repository is
for demonstration purposes only.
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

* [Contacts](#contact)

* [Disclaimer](#disclaim)

Introduction <a id="intro"></a>
-------------------------------

The artifacts within allow one to provision
MongoDB replica sets and agents-only pods into
OpenShift. It leverages
[MongoDB Ops Manager](https://www.mongodb.com/products/ops-manager)
for automation, monitoring, alerting, and backup functionality.
The basic design uses OpenShift to provision pods, each with 1
container running an instance of an automation agent.
Then REST API calls to MongoDB Ops Manager are invoked which,
in turn, install MongoDB instances into each pod and configures
the desired cluster.

Being a "developer preview" these artifacts can be treated as a
"functional prototype". Here we mean, this demonstrates
functionally how future MongoDB-supported product(s) will
operate. The actual implementation of any such future product(s)
is yet to be determined.

OpenShift specific, we use the new(er)
[Ansible Service Broker](https://github.com/openshift/ansible-service-broker)
available in OpenShift v3.7+. This broker registered services
to a central Service Catalog. The services are packaged as
[Ansible Playbook Bundles](https://github.com/ansibleplaybookbundle).
 This handiwork constitutes the majority
of the files in this repository.

<span style='color:red'>**_NOTE!_**</span> Being a new,
'prototype' project there are a number of detailed
steps required in order to use these components. Please be sure to
read this entire README _before_ attempting to get started.
Patience, young jedi, we call 'em README's for a reason.

Getting Started <a id="gs"></a>
-------------------------------

### Prerequisites

* A working MongoDB Ops Manager installation. Run through the
[install a simple test deployment](https://docs.opsmanager.mongodb.com/current/tutorial/install-simple-test-deployment/) instructions, and then see
[Ops Manager setup](#om-setup) for additional configuration steps.

* A working OpenShift environment, with the Ansible Service Broker.
A greate place to find info on building your development
environment is in the [APB Getting Started](https://github.com/ansibleplaybookbundle/ansible-playbook-bundle/blob/master/docs/getting_started.md).

* Please see the [Dependencies](#depends) section for
details on specific versions of software used.

* Consult the [Development Environement](#devenvtips)
section for tips on setting up your own
development environment.

* Finally, clone this repo

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

Also see [Issues](/issues?state=open) for more tips.


Development Environment Tips<a id="devenvtips"></a>
---------------------------------------------------

*Note:* All development was done on macOS Sierra 10.12.6

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
  * Create an API key & save to use to in configuration while provisioning
  * Add appropriate ips or `0.0.0.0/0` to the IP Whitelist

Known Issues & Limitations<a id="issues"></a>
---------------------------------------------

List of issues, Limitations, and to-dos.

All issues and limitations have moved to the
[Issues](/issues?state=open) part of this repo.

Contacts <a id="contact"></a>
-----------------------------

For technical questions, issues, sales and marketing support,
or just comments please email
[jason.mimick@mongodb.com](mailto://jason.mimick@mongodb.com) and
[dana.groce@mongodb.com](mailto://dana.groce@mongodb.com).


Disclaimer<a id="disclaim"></a>
-------------------------------

This software is not supported by [MongoDB, Inc.](http://mongodb.com)
under any of their commercial support subscriptions or otherwise.
Any usage of the mongodb-openshift-dev-preview is at your own risk.
Bug reports, feature requests and questions can be posted in the
[Issues](/issues?state=open) section on GitHub.
