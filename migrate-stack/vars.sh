#!/usr/bin/env bash

REMOTE_USER="helium"
REMOTE_HOST="helium.fdatxvault.win"

STACK_NAME="stack-vikunja"
DD_DIR="vikunja"

# Associative array mapping remote directories to local destinations
declare -A DIR_MAP=(
    ["/home/helium/gitsource/helium/${STACK_NAME}"]="/home/shahvirb/gitsource/argon/${STACK_NAME}"
    ["/home/helium/docker-data/${DD_DIR}/"]="/home/shahvirb/docker-data/${DD_DIR}/"
)
