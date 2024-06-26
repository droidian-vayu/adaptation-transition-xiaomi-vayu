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
ADAPTATION_LOG="/var/log/droidian-adaptation/adaptation-transition-xiaomi-vayu.log"

if [ -z $(dpkg -l | grep "adaptation-droidian-vayu") ]; then
    echo "The old adaptation-droidian-vayu is not installed, so the transition package will be removed" >> 
    ${ADAPTATION_LOG}
    # Remove the transition package 
    apt-get --purge remove -y adaptation-transition-xiaomi-vayu >> ${ADAPTATION_LOG}
    exit 0
fi

## Patch the script flash-bootimage to avoid errors whe linux-image is installed
sed -i 's|^GETPROP="$(choose_application.*|GETPROP="/usr/bin/getprop"|g' /usr/sbin/flash-bootimage
## Use .device property instead .model
sed -i 's/device_model=$(${GETPROP} ro.product.vendor.model/device_model=$(${GETPROP} ro.product.vendor.device/g' /usr/sbin/flash-bootimage

## Update apt archive
echo "Updating apt archive..." >> ${ADAPTATION_LOG}
apt-get update >> ${ADAPTATION_LOG}

## Checking prepared transition adaptation version availability
transition_version="0.1.5"
transition_version_found=$(apt-cache madison adaptation-droidian-vayu | grep "${transition_version}")
if [ -z "${transition_version_found}" ]; then 
    echo "The spected transition prepared adaptation version \"${transition_version}\" was not found!" \
	>> ${ADAPTATION_LOG}
    exit 1
fi

# Upgrade old adaptation-droidian-vayu and adaptation-vayu-configs packages to a non dependent desinstalable version
echo "Updating the old adaptation format package to a removable version..." >> ${ADAPTATION_LOG}
apt-get install -y adaptation-droidian-vayu adaptation-vayu-configs >> ${ADAPTATION_LOG}

# Remove the old adaptation-droidian-vayu and adaptation-vayu-configs packages
echo "Removing the old adaptation format package..." >> ${ADAPTATION_LOG}
apt-get --purge remove -y adaptation-droidian-vayu adaptation-vayu-configs >> ${ADAPTATION_LOG}

## Update apt archive
echo "Updating apt archive..." >> ${ADAPTATION_LOG}
apt-get update #> /dev/tty 2>/dev/null #| tee ${ADAPTATION_LOG}

# Install the new adaptation packages
echo "Installing the new adaptation format package including the linux image..." >> ${ADAPTATION_LOG}
apt-get install -y adaptation-xiaomi-vayu adaptation-xiaomi-vayu-configs >> ${ADAPTATION_LOG} 2>&1

## Reset templist to avoid conflicts with the list from the new adaptation
echo "" > /etc/apt/sources.list.d/vayu-tmp.list

## Update apt archive
echo "Updating apt archive..." >> ${ADAPTATION_LOG}
apt-get update #> /dev/tty 2>/dev/null #| tee ${ADAPTATION_LOG}

# Remove the transition package 
echo "Removing the adaptation-transition package..." >> ${ADAPTATION_LOG}
apt-get --purge remove -y adaptation-transition-xiaomi-vayu >> ${ADAPTATION_LOG}

## Update apt archive
echo "Updating apt archive..." >> ${ADAPTATION_LOG}
apt-get update #> /dev/tty 2>/dev/null #| tee ${ADAPTATION_LOG}
