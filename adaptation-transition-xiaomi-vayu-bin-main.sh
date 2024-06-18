#!/bin/bash

#[HEADER_SECTION]
#[HEADER_END]

# Upgrade old adaptation-droidian-vayu and adaptation-vayu-configs packages to a non dependent desinstalable version
apt-get update && apt-get install -y adaptation-droidian-vayu adaptation-vayu-configs

# Remove the old adaptation-droidian-vayu and adaptation-vayu-configs packages
apt-get --purge remove -y adaptation-droidian-vayu adaptation-vayu-configs

# Install the new adaptation packages
apt-get install -y adaptation-xiaomi-vayu adaptation-xiaomi-vayu-configs


exit 0
