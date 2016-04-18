#!/bin/bash
#This script will update Ubuntu and reboot system.

sudo apt-get update
sudo apt-get dist-upgrade
sudo apt-get autoremove
sudo reboot now
