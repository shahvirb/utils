#!/usr/bin/env bash

REMOTE_USER="helium"
REMOTE_HOST="helium.fdatxvault.win"

STACK_NAME="stack-scrutiny"
DD_DIR="scrutiny"

# Associative array mapping remote directories to local destinations
# WARNING: Trailing slashes matter! 
# - Remote path WITH trailing slash (dir/) copies contents into destination
# - Remote path WITHOUT trailing slash (dir) copies the directory itself, creating nested folder
declare -A DIR_MAP=(
    # ["/home/helium/gitsource/helium/${STACK_NAME}/"]="/home/shahvirb/gitsource/argon/${STACK_NAME}"
    ["/home/helium/docker-data/${DD_DIR}/"]="/home/shahvirb/docker-data/${DD_DIR}"
)
