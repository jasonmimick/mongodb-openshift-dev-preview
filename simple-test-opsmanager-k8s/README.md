om-on-k8s
=========


Simple Test Ops Manager running inside k8s.

Note: the docker/content directory is generated
do NOT put anything you want to keep there!

- Dynamically builds image from mongodb & mms builds
- Other fixed content for image is store in the ./src folder

Getting started
---------------

Note - this should work with `minikube` or `minishift`. Of course,
the OpenShift template included only work with minishift.

1. Build the images. Run `./build-image.sh`. Note you can override
where the MongoDB and Ops Manager archive are located in the script.

2. Start `minishift --openshift-version=v3.9.0 --memory=8GB`. 
(Run with a least 8GB of ram for Ops Manager, add more if needed.)

3. `eval $(minishift docker)`

4. `kubectl apple -f ./mongodb-opsmgr-appdb.yaml`

5. Edit the Config Map defined in `./mongodb-opsmgr-global-config.yaml`
with whatever user/pass you want. Then load into k8s.

```
kubectl apply -f ./mongodb-opsmgr-global-config.yaml
```

5. `kubectl apply -f ./mongodb-opsmgr.yaml`
Wait for Ops Mgr to be ready.

6. `oc expose service mongodb-opsmgr` 
Then you should have a URL you can access in a browser to get 
to the new test Ops Manager instance running in k8s.

6. For the OpenShift template you need to update the APIKEY. One
is generated. You can see it with:

```
kubectl exec mongodb-opsmgr -- cat /mongodb-mms/opsmgr-config-map.yaml
```

7. Create a MongoDB replica set

```
oc new-app --file mongodb-openshift-dev-preview.template.yaml --param=NAMESPACE=myproject
```


