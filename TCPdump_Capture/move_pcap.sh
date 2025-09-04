#!/bin/bash
# move_pcap.sh
# This script moves the rotated pcap file to a new directory.
# Use:
# move_pcap.sh /tmp /pcap

SOURCE_DIR="$1"
DEST_DIR="$2"

# Create the destination directory if it doesn't exist
#mkdir -p "$DEST_DIR"

# Move the file
mv "$SOURCE_DIR"/*.gz "$DEST_DIR/"

echo "Moved $SOURCE_DIR to $DEST_DIR"