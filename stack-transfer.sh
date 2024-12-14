#!/bin/bash

REMOTE_USER="helium"
REMOTE_HOST="helium"

# Define an associative array to map remote directories to local destinations
declare -A DIR_MAP=(
    ["/home/helium/gitsource/helium/stack-openproject"]="/home/shahvirb/gitsource/argon/stack-openproject"
)

# Loop through each remote-local pair in the map
for REMOTE_DIR in "${!DIR_MAP[@]}"; do
    LOCAL_DIR="${DIR_MAP[$REMOTE_DIR]}"

    echo "Copying $REMOTE_DIR to $LOCAL_DIR..."

    # Create the local directory if it doesn't exist
    mkdir -p "$LOCAL_DIR"

    # Execute the SCP command
    scp -r "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR" "$LOCAL_DIR"

    # Check if the copy was successful
    if [ $? -eq 0 ]; then
        echo "Successfully copied $REMOTE_DIR to $LOCAL_DIR."
    else
        echo "Failed to copy $REMOTE_DIR to $LOCAL_DIR." >&2
    fi
done

echo "All directories processed."
