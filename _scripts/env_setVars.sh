#!/bin/sh

#set -e

export TELEGRAM_ADMIN=$(cat _protected/sec_tg_id.txt) && echo $TELEGRAM_ADMIN
export TELEGRAM_TOKEN=$(cat _protected/sec_tg_token.txt) && echo $TELEGRAM_TOKEN
