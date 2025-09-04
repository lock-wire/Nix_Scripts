#!/bin/bash

# Capture all traffic on the 'any' interface and write to rotating files.
# Adjust interface (-i), file size (-C), capture time in seconds (-G), user run as (-Z) and filename (-w) as needed.
# The postrotate option (-z) points to a script to write the final pcap in new location.
tcpdump -i enp0s31f6 -Z user -C 100 -G 3600 -z /usr/local/etc/rotate_pcap.sh -w '/pcap/tcpdump/tcpdump_%Y%m%d_%H%M%S.pcap' -s0 -U