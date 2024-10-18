#!/usr/bin/env bash

DIR_NAME="stack-$1"
mkdir "$DIR_NAME" && cd "$DIR_NAME"
ln -s ../.env .env
echo "services:" > docker-compose.yaml