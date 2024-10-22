#!/usr/bin/env bash

cd /etc/nixos
no_changes=true

# Check for pending changes
if git diff-index --quiet HEAD --; then
    echo "No pending changes detected."
else
    echo "Pending changes detected. Please commit or stash your changes."
    no_changes=false
fi

# Proceed based on the flag value
if [ "$no_changes" = true ]; then
    echo "git pull"
    git pull
    echo "git reset --hard @{u}"
    git reset --hard @{u}
    echo "git status"
    git status
else
    echo "Exiting due to pending changes."
    exit 1
fi
