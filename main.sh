#!/bin/sh

BASEDIR=$(dirname $(readlink -f  $0))

echo "Logging in openshift..."
oc login https://minishift:8443 -u developer -p developer >> /dev/null
#oc login https://ocp.marcosmamorim.com.br:8443 -u mohashi -p r3dh4t1! >> /dev/null
#oc login https://open.paas.redhat.com:443 -u mohashi -p Fake@339!

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
