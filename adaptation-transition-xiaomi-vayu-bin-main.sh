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

set -e

[ -z $(dpkg -l | grep "adaptation-droidian-vayu") ]  && echo "adaptation-droidian-vayu is not installed!" && exit 0

## Patch the vayu.list to the new repo
old_vayu_list="/usr/lib/adaptation-droidian-vayu/sources.list.d/vayu.list"
[ ! -f "${old_vayu_list}" ] && echo "Old vayu.list file not found!" && exit 1
cat /usr/share/keyrings/vayu-new.gpg > /usr/share/keyrings/vayu.gpg 
sed -i '/vacuumbeef/droidian-vayu/g' "${old_vayu_list}"
sed -i '/vayu-repo/apt-xiaomi-vayu/g' "${old_vayu_list}"

## Update repos
apt-get update

# Upgrade old adaptation-droidian-vayu and adaptation-vayu-configs packages to a non dependent desinstalable version
apt-get install -y adaptation-droidian-vayu adaptation-vayu-configs
# Remove the old adaptation-droidian-vayu and adaptation-vayu-configs packages
apt-get --purge remove -y adaptation-droidian-vayu adaptation-vayu-configs

# Install the new adaptation packages
apt-get install -y adaptation-xiaomi-vayu adaptation-xiaomi-vayu-configs

# Remove the transition package 
apt-get --purge remove -y adaptation-transition-xiaomi-vayu

