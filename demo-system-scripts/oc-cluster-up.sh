#!/bin/bash

./openshift-origin-client-tools-v3.9.0-191fece-linux-64bit/oc cluster up \
 --routing-suffix=origin-asb.mongodbpartners.net \
 --image=docker.io/openshift/origin \
 --public-hostname=origin-asb.mongodbpartners.net \
 --version=v3.7.0 \
 --server-loglevel=5 \
 --loglevel=5 \
 --service-catalog=false
