#!/bin/bash

DEST=../current
SRC=tests
VERSION_ARG=''


##..stop DockerCompose current Stack
clear
echo "--STEP0: Stopping current DockerCompose Stack.."
# pwd                                 ## ~/projects/sf-c0207-hw-prometheus-stack-docker/current
#cp -r ../$SRC/stack_v00/* $DEST/
docker compose down
#echo
#docker ps
echo
echo
#exit

##--Selecting current dir (disabled)
#cd "$(dirname "$0")"
#pwd                                 ## ~/projects/sf-c0207-hw-prometheus-stack-docker/current

if [[ $1 == "" ]]
then
  VERSION_ARG=v00
fi
if [[ $1 != "" ]]
then
  VERSION_ARG=$1
fi


echo "--STEP1: Copying new DockerCompose configs and Starting NEW Stack.."
rm -rf $DEST/*
cp -r ../$SRC/stack_$VERSION_ARG/* $DEST/
cp ../$SRC/stack_$VERSION_ARG/.env $DEST/
source .env

echo $SRC/stack_$VERSION_ARG
echo
tree -L 1 $DEST/
echo
echo

echo "--STEP2: Checking running NEW Stack Containers.."
echo
docker compose up -d
echo
docker ps
echo
