#!/bin/bash

# Set ageing and forwarding for bridge interface intended for promiscuous monitoring.
# Place in /usr/local/etc/
# chmod +x /usr/local/etc/set-promisc-bridge.sh
# (sudo crontab -e) @reboot /usr/local/etc/set-promisc-bridge.sh
interface="br0"

until ip a s dev br0 | grep -q "state UP"; do 
    sleep 1
done

brclt setageing $interface 0
brctl setfd $interface 0
