#!/bin/sh

CONFIGDIR=$(dirname $(readlink -f  $0))/scripts/config

#Create Gogs Database
oc new-app postgresql-persistent \
    --param POSTGRESQL_DATABASE=gogs \
    --param POSTGRESQL_USER=gogs \
    --param POSTGRESQL_PASSWORD=gogs \
    --param VOLUME_CAPACITY=4Gi \
    --param DATABASE_SERVICE_NAME=postgresql-gogs \
    -lapp=postgresql-gogs

sleep 50s

#Create Gogs app
oc new-app wkulhanek/gogs:11.4 -lapp=gogs

sleep 50s

#Create gogs-data
echo "apiVersion: v1
kind: PersistentVolumeClaim
metadata:
    name: gogs-data
spec:
    accessModes:
    - ReadWriteOnce
    resources:
        requests:
            storage: 4Gi" | oc create -f -

#Create Gogs volume
oc set volume dc/gogs --add \
    --overwrite --name=gogs-volume-1 \
    --mount-path=/data/ --type persistentVolumeClaim \
    --claim-name=gogs-data

#Expose Gogs service
oc expose svc gogs

#Create Gogs configmap
oc create configmap gogs \
    --from-file=$CONFIGDIR/gogs/app.ini

oc set volume dc/gogs --add --overwrite \
    --name=config-volume -m /opt/gogs/custom/conf/ \
    -t configmap --configmap-name=gogs