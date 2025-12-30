#!/usr/bin/env bash

# Usage: ./bundle_cmd.sh
# Generates commands to create a bundle archive on a remote host.
# Outputs a series of shell commands that can be copy-pasted and executed on the remote system.
# Useful for creating bundles on servers where this script cannot run directly.

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

echo "# Run these commands on ${REMOTE_HOST} as ${REMOTE_USER}:"
echo ""
echo "# Create the tar.gz archive"
echo "tar -czf ~/${ARCHIVE_NAME} \\"

# Output each directory to bundle
for i in "${!DIRS_TO_BUNDLE[@]}"; do
    dir="${DIRS_TO_BUNDLE[$i]}"
    if [ $i -eq $((${#DIRS_TO_BUNDLE[@]} - 1)) ]; then
        # Last item, no backslash
        echo "  \"${dir}\""
    else
        # Not last item, add backslash for continuation
        echo "  \"${dir}\" \\"
    fi
done

echo ""
echo "# Verify the archive was created"
echo "ls -lh ~/${ARCHIVE_NAME}"
echo ""
echo "# Optional: View archive contents"
echo "tar -tzf ~/${ARCHIVE_NAME} | head -20"
