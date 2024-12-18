#!/usr/bin/env bash

# delete.sh - Deletes all directories defined in DIR_MAP on the remote server

# Source the variables from vars.sh
source "$(dirname "$0")/vars.sh"

# Confirm before proceeding
echo "This will delete the following directories on the remote server (${REMOTE_USER}@${REMOTE_HOST}):"
for REMOTE_DIR in "${!DIR_MAP[@]}"; do
    echo " - $REMOTE_DIR"
done

read -p "Are you sure you want to continue? (yes/no): " CONFIRM
if [[ "$CONFIRM" != "yes" ]]; then
    echo "Deletion cancelled."
    exit 0
fi

# Loop through each directory and delete it on the remote server
for REMOTE_DIR in "${!DIR_MAP[@]}"; do
    echo "Deleting $REMOTE_DIR on $REMOTE_HOST..."

    # Run the SSH command to delete the directory
    ssh "$REMOTE_USER@$REMOTE_HOST" "rm -rf \"$REMOTE_DIR\""

    # Check if the deletion was successful
    if [ $? -eq 0 ]; then
        echo "Successfully deleted $REMOTE_DIR."
    else
        echo "Failed to delete $REMOTE_DIR." >&2
    fi
done

echo "Directories have been deleted."
