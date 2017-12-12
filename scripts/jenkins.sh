#!/bin/sh

oc new-app jenkins-persistent --param ENABLE_OAUTH=true \
    --param MEMORY_LIMIT=2Gi --param VOLUME_CAPACITY=4Gi \
    --param JENKINS_IMAGE_STREAM_TAG=jenkins:v3.7.9-21