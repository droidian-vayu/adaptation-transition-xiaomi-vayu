#!/bin/bash

#[HEADER_SECTION]
#[HEADER_END]

set -e

[ -z $(dpkg -l | grep "adaptation-droidian-vayu") ]  && echo "adaptation-droidian-vayu is not installed!" && exit 0

# Upgrade old adaptation-droidian-vayu and adaptation-vayu-configs packages to a non dependent desinstalable version
apt-get update && apt-get install -y adaptation-droidian-vayu adaptation-vayu-configs

# Remove the old adaptation-droidian-vayu and adaptation-vayu-configs packages
apt-get --purge remove -y adaptation-droidian-vayu adaptation-vayu-configs

# Install the new adaptation packages
apt-get install -y adaptation-xiaomi-vayu adaptation-xiaomi-vayu-configs

# Remove the transition package 
apt-get --purge remove -y adaptation-transition-xiaomi-vayu

