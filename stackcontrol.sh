#!/usr/bin/env bash

COMMAND=$1

# Append --detach if the command is "up"
if [ "$COMMAND" == "up" ]; then
    COMMAND="up --detach"
fi

execute_docker_compose() {
    dir=$1
    cmd="$2"

    echo "Executing 'docker compose $cmd' in directory $dir"
    (cd "$dir" && docker compose $cmd)
    echo
}

# Export the function so it's available to the subshell spawned by find
export -f execute_docker_compose

# Find docker-compose.yaml files and execute the function in their directories
find . -name 'docker-compose.yaml' -exec dirname {} \; | sort -u | while read dir; do execute_docker_compose "$dir" "$COMMAND"; done