#!/bin/bash
#
## Script to apply the transition from old adaptation-droidian-vayu to the new adaptation-xiaomi-vayu
#
# Upstream-Name: adaptation-transition-xiaomi-vayu
# Source: https://github.com/droidian-vayu/adaptation-transition-xiaomi-vayu
#
# Copyright (C) 2024 Berbascum <berbascum@ticv.cat>
# All rights reserved.
#
# BSD 3-Clause License


#[HEADER_SECTION]
#[HEADER_END]

[ -z $(dpkg -l | grep "adaptation-droidian-vayu") ]  && echo "adaptation-droidian-vayu is not installed!" && exit 0

## Update repos
apt-get update

# Upgrade old adaptation-droidian-vayu and adaptation-vayu-configs packages to a non dependent desinstalable version
apt-get install -y adaptation-droidian-vayu adaptation-vayu-configs
# Remove the old adaptation-droidian-vayu and adaptation-vayu-configs packages
apt-get --purge remove -y adaptation-droidian-vayu adaptation-vayu-configs

# Install the new adaptation packages
apt-get install -y adaptation-xiaomi-vayu adaptation-xiaomi-vayu-configs

## Reset templist to avoid conflicts with the list from the new adaptation
echo "" > /etc/apt/sources.list.d/vayu.tmp.list

## Update repos
apt-get update

# Remove the transition package 
apt-get --purge remove -y adaptation-transition-xiaomi-vayu

