#!/bin/bash

# Monitor Suricata PCAP directory for file close events to ensure Suricata
# had finished writing a pcap file. On a close file event, symlink the pcap file to 
# another location.
# (USAGE) suripcap-monitor [monitor folder] [symlink destination]

# Set Arguments to variables
suripcap=$1
symdest=$2

# Set logfile
LOGFILE="/var/log/teleseer/suripcap-monitor.log"
touch $LOGFILE

# Redirect stdout to log file for entire script
exec > "$LOGFILE"

inotifywait -m -r -e close_write --include 'so-pcap.*' "$suripcap" |
  while read -r path action file; do
    ln -s "$path$file" "$symdest$file"
    echo "$(date) $path$file symlink created at $symdest$file"
done
