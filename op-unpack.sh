#!/usr/bin/env bash

DEBUG=false  # Debug flag, initially set to false
matched_env_file=""

log_debug() {
    if [ "$DEBUG" = true ]; then
        echo "[DEBUG] $1"
    fi
}

process_tpl_file() {
    local tpl_file="$1"
    local output_file="${tpl_file%.tpl}"  # Remove the .tpl extension
    log_debug "Processing template file: $tpl_file -> $output_file"

    echo "op inject -f -i $tpl_file -o $output_file"
    op inject -f -i "$tpl_file" -o "$output_file"

    if [ $? -eq 0 ]; then
        echo "Successfully unpacked: $tpl_file"
    else
        echo "Failed to unpack: $tpl_file"
        exit 1  # Exit on failure
    fi
}

process_env_files() {
    local env_files=("$@")

    for env_file in "${env_files[@]}"; do
        log_debug "Scanning env file: $env_file"
        if grep -q "op://" "$env_file"; then
            echo "Found matching 'op://' in: $env_file"
            if [ -z "$matched_env_file" ]; then
                matched_env_file="$env_file"
            else
                echo "ERROR - Only one matching env file is allowed. Conflict with: $env_file"
                exit 1
            fi
        else
            log_debug "Skipping env file: $env_file (no 'op://' found)"
        fi
    done
}

# Parse arguments for '--debug' and everything after the '--'
for i in "$@"; do
    case "$i" in
        --debug)
            DEBUG=true  # Enable debug mode
            log_debug "Debug mode enabled"
            ;;
        --)
            shift  # Shift to the next arguments after '--'
            break
            ;;
    esac
    shift  # Ignore arguments before '--'
done

# Recursively process all .tpl files in the current directory
log_debug "Searching for .tpl files..."
find . -type f -name "*.tpl" | while read -r tpl_file; do
    process_tpl_file "$tpl_file"
done

# Find all *.env files and store them in an array
log_debug "Searching for .env files..."
mapfile -t env_files < <(find . -type f -name "*.env")
process_env_files "${env_files[@]}"

# Execute the command provided after '--'
if [[ $# -gt 0 ]]; then
    if [ -n "$matched_env_file" ]; then
        echo "Running command with $matched_env_file: $@"
        op run --env-file="$matched_env_file" -- "$@"
    else
        echo "Command: $@"
        "$@"
    fi
else
    echo "No command provided to run."
fi