simple-test-opsmanager-k8s
==========================
*Inspired by [Simple Test Deployment](https://docs.opsmanager.mongodb.com/current/tutorial/install-simple-test-deployment/)*


Simple Test Ops Manager running inside k8s.

Note: the docker/content directory is generated
do NOT put anything you want to keep there!

- Dynamically builds image from mongodb & mms builds
- Other fixed content for image is store in the ./src folder

Getting started
---------------

Note - this should work with `minikube` or `minishift`. Of course, the OpenShift template included only works with minishift.

If you're using this with `minikube`, just substitute the `kubectl` command for the `oc` command below (and, `minikube` for `minishift`).

1. Build the images. Run `./build-image.sh`. Note you can override where the MongoDB and Ops Manager archive are located in the script.

2. Start `minishift start --openshift-version=v3.9.0 --memory=8GB`.  (Run with a least 8GB of ram for Ops Manager, add more if needed.)

Note: I needed to do some secrutiy stuff to get the default admin and developer accounts the correct roles to do things in OpenShift.
Here's the script I run, probably this does way more than is really needed:

```
#!/bin/bash
oc login -u system:admin
oc adm policy add-scc-to-user anyuid -z default
oc adm policy add-scc-to-group anyuid system:authenticated
oc adm policy add-cluster-role-to-user cluster-admin developer
oc adm policy add-cluster-role-to-user cluster-admin admin
```

3. `eval $(minishift docker-env)`

4. Run the following to load the need docker image into the local minishift docker registry:

```
docker build docker/simple-test-opsmanager-k8s -t simple-test-opsmanager-k8s:beta -f docker/simple-test-opsmanager-k8s/Dockerfile
```

5. `oc apply -f ./mongodb-opsmgr-appdb.yaml`

6. Edit the Config Map defined in `./mongodb-opsmgr-global-config.yaml` with whatever user/pass you want. Then load into k8s.

```
oc apply -f ./mongodb-opsmgr-global-admin.yaml
```

7. `oc apply -f ./mongodb-opsmgr.yaml`
Wait for Ops Mgr to be ready.

8. `oc expose service mongodb-opsmgr` 
Then you should have a URL you can access in a browser to get  to the new test Ops Manager instance running in k8s.

9. For the OpenShift template you need to update the APIKEY. One is generated in the mongodb-opsmgr container. You can see it with:

```
oc exec mongodb-opsmgr -- cat /mongodb-mms/opsmgr-config-map.yaml
```

10. Create a MongoDB replica set. One way is on the command line:

```
oc new-app --file mongodb-openshift-dev-preview.template.yaml --param=NAMESPACE=myproject
```
Note, there are defaults for all the parmeters in the template except Namespace.


I was able to get the template to show up in the OpenShift web console with, 

```
oc create -f mongodb-openshift-dev-preview.template.yaml -n openshift
```


