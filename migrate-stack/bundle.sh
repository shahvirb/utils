#!/usr/bin/env bash

# Usage: ./bundle.sh
# Creates a timestamped tar.gz archive containing all directories defined in vars.sh.
# Archive will be saved in the current directory with format: {STACK_NAME}_bundle_{timestamp}.tar.gz

set -e

# Source variables
source "$(dirname "$0")/vars.sh"

# Extract directories to archive (left side of DIR_MAP)
DIRS_TO_BUNDLE=()
for dir in "${!DIR_MAP[@]}"; do
    DIRS_TO_BUNDLE+=("$dir")
done

# Create archive name with timestamp
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
ARCHIVE_NAME="${STACK_NAME}_bundle_${TIMESTAMP}.tar.gz"

echo "Creating archive: ${ARCHIVE_NAME}"
echo "Bundling directories:"
for dir in "${DIRS_TO_BUNDLE[@]}"; do
    echo "  - $dir"
done

# Create tar.gz archive preserving permissions
# Using -C / to make paths relative from root, then stripping leading /
tar -czf "${ARCHIVE_NAME}" -C / "${DIRS_TO_BUNDLE[@]#/}"

echo "Archive created successfully: ${ARCHIVE_NAME}"
echo "Size: $(du -h "${ARCHIVE_NAME}" | cut -f1)"
