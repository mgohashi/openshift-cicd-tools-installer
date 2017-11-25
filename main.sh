#!/bin/sh

BASEDIR=$(dirname $(readlink -f  $0))

echo "Logging in openshift..."
oc login "$1" >> /dev/null

if [ "$?" == "0" ]; then
    echo "Creating cicd project..."
    oc new-project mo-cicd

    echo "Deploying Gogs..."
    source $BASEDIR/scripts/gogs.sh

    sleep 3m

    echo "Deploying Jenkins..."
    source $BASEDIR/scripts/jenkins.sh

    sleep 3m

    echo "Deploying Nexus3..."
    source $BASEDIR/scripts/nexus3.sh

    sleep 3m

    echo "Deploying SonarQube..."
    source $BASEDIR/scripts/sonarqube.sh

    sleep 3m
else
    echo "Could not log in Openshift!"
fi
