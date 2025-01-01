#!/usr/bin/env bash

# Check if the directory argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

DIRECTORY=$1
FILE="$DIRECTORY/test.txt"

# Try to touch the file and capture any errors
if touch "$FILE" 2>/dev/null; then
    echo "File created successfully."
    rm "$FILE"
    exit 0
else
    touch "$FILE"
    exit $?
fi