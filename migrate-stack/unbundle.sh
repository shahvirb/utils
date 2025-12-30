#!/usr/bin/env bash

# Usage: sudo ./unbundle.sh <archive.tar.gz>
# Extracts a bundle archive and restores directories to their configured destinations.
# Requires sudo to preserve file permissions and ownership.
# Prompts for confirmation before overwriting existing directories.
# Run without arguments to see available archives.

set -e

# Source variables
source "$(dirname "$0")/vars.sh"

# Check if archive file is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <archive.tar.gz>"
    echo ""
    echo "Available archives:"
    ls -1t ${STACK_NAME}_bundle_*.tar.gz 2>/dev/null | head -5 || echo "  No archives found"
    exit 1
fi

ARCHIVE="$1"

if [ ! -f "$ARCHIVE" ]; then
    echo "Error: Archive not found: $ARCHIVE"
    exit 1
fi

echo "Extracting from archive: $ARCHIVE"
echo ""

# Create a temporary directory for extraction
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

# Extract the entire archive to temp directory
echo "Extracting archive to temporary location..."
tar -xzpf "$ARCHIVE" -C "$TEMP_DIR"

# Map extracted directories to their destinations
for source_dir in "${!DIR_MAP[@]}"; do
    dest_dir="${DIR_MAP[$source_dir]}"
    
    # Remove leading slash for path in temp dir
    temp_path="$TEMP_DIR${source_dir}"
    
    echo "Processing: $source_dir -> $dest_dir"
    
    if [ ! -e "$temp_path" ]; then
        echo "  Warning: Source path not found in archive: $source_dir"
        continue
    fi
    
    # Create parent directory if needed
    parent_dir=$(dirname "$dest_dir")
    mkdir -p "$parent_dir"
    
    # Check if destination exists and ask user what to do
    if [ -e "$dest_dir" ]; then
        echo "  Warning: Destination already exists: $dest_dir"
        read -p "  Do you want to create a backup and continue? (y/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "  Aborting extraction."
            exit 1
        fi
        backup_path="${dest_dir}.backup.$(date +%Y%m%d_%H%M%S)"
        echo "  Creating backup: $backup_path"
        mv "$dest_dir" "$backup_path"
    fi
    
    # Move extracted content to destination
    mv "$temp_path" "$dest_dir"
    echo "  ✓ Extracted to: $dest_dir"
done

echo ""
echo "Extraction complete!"
