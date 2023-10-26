#!/bin/sh

#set -e

##--Connect to Container shell by Container name
##
docker exec -it $1 /bin/sh


##..Examples (0)
##
##  $ docker run -it --rm --network=test redis:alpine redis-cli -h redis
##

##..Examples (1)
##
##  $ docker ps
##
##          CONTAINER ID   IMAGE                                              STATUS    NAMES
##          d5dd8fe9eaf7   prom/alertmanager:v0.26.0                          Up        alertmanager
##          39b702ecc338   prom/prometheus:latest                             Up        prometheus
##          1348b0defe4c   gcr.io/cadvisor/cadvisor:v0.46.0                   Up        cadvisor
##          18a318c02f7f   portainer/portainer-ce:linux-amd64-2.19.1-alpine   Up        portainer
##          5f7a4ada098e   prom/node-exporter                                 Up        node-exporter
##          868ea671ddd8   redis:alpine                                       Up        redis
##
##  $ docker exec -it 868ea671ddd8 /bin/sh
##  $ docker exec -it redis /bin/sh
##  $ docker exec -it redis /usr/local/bin/redis-cli
##  $ docker exec -it redis redis-cli -h redis
##  $ ../_scripts/docker_conn2Container.sh redis
##
##          /data # hostname        ## 868ea671ddd8
##          /data # exit
##
