#!/usr/bin/env bash

REMOTE_USER="helium"
REMOTE_HOST="helium.fdatxvault.win"

STACK_NAME="stack-tandoor"
DD_DIR="tandoor"

# Associative array mapping remote directories to local destinations
declare -A DIR_MAP=(
    ["/home/helium/gitsource/helium/${STACK_NAME}"]="/home/shahvirb/gitsource/argon/${STACK_NAME}"
    ["/home/helium/docker-data/${DD_DIR}"]="/home/shahvirb/docker-data/${DD_DIR}"
    ["/home/helium/gitsource/helium/${STACK_NAME}/ng.tar"]="/home/shahvirb/gitsource/argon/${STACK_NAME}/ng.tar"
    ["/home/helium/gitsource/helium/${STACK_NAME}/sf.tar"]="/home/shahvirb/gitsource/argon/${STACK_NAME}/sf.tar"
    # ["/var/lib/docker/volumes/stack-tandoor_nginx_config]="/var/lib/docker/volumes/stack-tandoor_nginx_config/"
    # ["/var/lib/docker/volumes/stack-tandoor_staticfiles]="/var/lib/docker/volumes/stack-tandoor_staticfiles/"
)
