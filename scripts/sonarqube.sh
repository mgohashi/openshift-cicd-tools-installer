#!/bin/sh

#Create SonarQube Database
oc new-app postgresql-persistent \
    --param POSTGRESQL_USER=sonar \
    --param POSTGRESQL_PASSWORD=sonar \
    --param POSTGRESQL_DATABASE=sonar \
    --param VOLUME_CAPACITY=4Gi \
    --param DATABASE_SERVICE_NAME=postgresql-sonar \
    -lapp=sonarqube

sleep 10s

#Create SonarQube App
oc new-app wkulhanek/sonarqube:6.4 \
    -e SONARQUBE_JDBC_USERNAME=sonar \
    -e SONARQUBE_JDBC_PASSWORD=sonar \
    -e SONARQUBE_JDBC_URL=jdbc:postgresql://postgresql-sonar/sonar \
    -lapp=sonarqube

sleep 10s

#Expose SonarQube service
oc expose service sonarqube --port=9000

#Pause Rollout
oc rollout pause dc sonarqube

sleep 10s

#Adding probes
oc set probe dc/sonarqube --liveness \
    --failure-threshold 3 \
    --initial-delay-seconds 180 \
    -- echo ok

oc set probe dc/sonarqube --readiness \
    --failure-threshold 3 \
    --initial-delay-seconds 180 \
    --get-url=http://:9000/about

oc rollout resume dc sonarqube