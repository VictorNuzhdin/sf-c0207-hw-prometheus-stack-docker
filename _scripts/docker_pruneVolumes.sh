#!/bin/bash

##..selecting current dir
cd "$(dirname "$0")"


## Clearing Docker Environment
## *removing unused stopped containers
## *removing unused volumes
#
#docker rm $(docker ps --filter status=exited -q)
#docker ps --filter status=exited -q | xargs docker rm
docker volume prune --all --force > ./logs/docker_clear__$(date +'%Y%m%d_%H%M%S').log
