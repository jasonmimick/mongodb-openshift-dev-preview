simple-test-opsmanager-k8s
=======
*Inspired by [Simple Test Deployment](https://docs.opsmanager.mongodb.com/current/tutorial/install-simple-test-deployment/)*

```

 _  _   __   __ _   ___   __  ____  ____        __  ____  ____  _  _   ___  ____      __ _  ____  ____ 
( \/ ) /  \ (  ( \ / __) /  \(    \(  _ \ ___  /  \(  _ \/ ___)( \/ ) / __)(  _ \ ___(  / )/ _  \/ ___)
/ \/ \(  O )/    /( (_ \(  O )) D ( ) _ ((___)(  O )) __/\___ \/ \/ \( (_ \ )   /(___))  ( ) _  (\___ \
\_)(_/ \__/ \_)__) \___/ \__/(____/(____/      \__/(__)  (____/\_)(_/ \___/(__\_)    (__\_)\____/(____/
```



Simple Test Ops Manager running inside k8s.

Note: the docker/content directory is generated
do NOT put anything you want to keep there!

- Dynamically builds image from mongodb & mms builds
- Other fixed content for image is store in the ./src folder

Getting started
---------------

Note - this should work with `minikube`.
If you don't know what `minikube` is, then you know what do, right?

Enterprise users, see below for `minishift`. 

1. Start `minikube start --memory="8000"`
(Run with a least 8GB of ram for Ops Manager, add more if needed.)
=======

2. Build the images. Run `./build-image.sh`. Note you can override
where the MongoDB and Ops Manager archive are located in the script.
The `build-image.sh` script will attempt to find the newest Ops Mgr
build. But, in order for this to work, you need to have a local
version of the Ops Mgr github repository (https://github.com/10gen/mms).
Otherwise, the build script will use the URL located in `./default-latest-mms-build`

2a. The `./build-image.sh` should do this, but make sure your local
`minishift` `docker` registry actually has the image, if not, then
run  `eval $(minishift docker-env)`


3. `kubectl create -f ./simple-test-opsmgr.yaml`
Wait for Ops Mgr to be ready.



#WORKING AREA#

```
kubectl exec -it $(kubectl get pods --selector=app=mongodb-opsmgr --output=jsonpath='{.items[0].metadata.name}') -c mongodb-opsmgr -- tail -f /mongodb-opsmgr-server/runtime/startup-mms.log
```

```
kubectl exec mongodb-opsmgr -c mongodb-opsmgr -- cat mongodb-opsmgr-server/runtime/opsmgr-config-map.yaml | kubectl create -f -
```
Now - get your helm going....
