#!/usr/bin/env bash

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
