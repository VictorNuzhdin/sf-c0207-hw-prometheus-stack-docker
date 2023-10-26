#!/bin/sh

#set -e

#SCRIPTS_PATH=_scripts
#cd "$(dirname "$0")"
#$SCRIPTS_PATH/set-env.sh

clear && docker compose down && docker compose up -d && docker ps
