#!/bin/bash
# rotate_pcap.sh
# This script moves pcap to a new directory during tcpdump post-rotate

source /usr/local/etc/capture_variables.txt

# Move the file
mv "$1" "$DEST_DIR/"

# todo
# check path and create
# logging