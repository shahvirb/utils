#!/usr/bin/env bash

# Usage: ./copy.sh
#
# Description:
#   Copies directories from a remote host to local directories using rsync.
#   The remote-to-local directory mappings are defined in vars.sh (DIR_MAP).
#
# Prerequisites:
#   - vars.sh must be present in the same directory
#   - SSH access to the remote host configured (REMOTE_USER@REMOTE_HOST)
#   - rsync installed on both local and remote systems
#
# Configuration:
#   Edit vars.sh to set:
#   - REMOTE_USER: SSH username for remote host
#   - REMOTE_HOST: Remote hostname or IP address
#   - DIR_MAP: Associative array mapping remote directories to local directories
#
# Example:
#   ./copy.sh
#   (No arguments required - configuration is in vars.sh)

source "$(dirname "$0")/vars.sh"

# Loop through each remote-local pair in the map
for REMOTE_DIR in "${!DIR_MAP[@]}"; do
    LOCAL_DIR="${DIR_MAP[$REMOTE_DIR]}"

    echo "Copying $REMOTE_DIR to $LOCAL_DIR..."

    # Create the local directory if it doesn't exist
    mkdir -p "$LOCAL_DIR"

    rsync -av --progress "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR" "$LOCAL_DIR"
    # rsync -av --progress -e "ssh -X" --rsync-path="sudo -A rsync" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR" "$LOCAL_DIR"

    # Check if the copy was successful
    if [ $? -eq 0 ]; then
        echo "Successfully copied $REMOTE_DIR to $LOCAL_DIR."
    else
        echo "Failed to copy $REMOTE_DIR to $LOCAL_DIR." >&2
    fi
done

echo "All directories processed."
