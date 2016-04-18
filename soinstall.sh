#!/bin/bash
#Install Security Onion on a headless Ubuntu 14.04 server

#Configure MSQL not to prompt for root password.
echo "debconf debconf/frontend select noninteractive" | sudo debconf-set-selections

#Install python-software-properties
sudo apt-get -y install python-software-properties

#Add the Security Onion stable repository, update, and install
sudo add-apt-repository -y ppa:securityonion/stable
sudo apt-get update
sudo apt-get -y install securityonion-all syslog-ng-core

#Uncomment to install Salt for distributed management of sensors.
#sudo apt-get -y install securityonion-onionsalt

echo Security Onion installation complete. SSH into this device  (ssh -X yourSO@yourSOIP) and run "sudo sosetup".