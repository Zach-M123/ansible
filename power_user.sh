#!/bin/bash

# Color Definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Host lists grouped by OS
RHEL_HOSTS=("192.168.122.105" "192.168.122.25" "192.168.122.122" "192.168.122.176" "192.168.122.169" "192.168.122.196" "192.168.122.205" "192.168.122.136")
UBUNTU_HOSTS=("192.168.122.141" "192.168.122.213" "192.168.122.61" "192.168.122.242")

REMOTE_USER="zach"

configure_sudo() {
    local IP=$1
    local CONTENT=$2
    
    echo -e "${PURPLE}---------------------------------------${NC}"
    echo "Configuring sudo for: $IP"

    # We use 'tee' to write to the protected directory and 'chmod' to set 0440 permissions
    ssh -o StrictHostKeyChecking=no "$REMOTE_USER@$IP" \
    "echo '$CONTENT' | sudo tee /etc/sudoers.d/zach > /dev/null && sudo chmod 0440 /etc/sudoers.d/zach"

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Success: $IP configuration applied.${NC}"
    else
        echo -e "${RED}Failed: $IP configuration failed.${NC}"
    fi
}

# Process RHEL & Oracle (Same syntax)
for IP in "${RHEL_HOSTS[@]}"; do
    configure_sudo "$IP" "zach ALL=(ALL:ALL) NOPASSWD: ALL"
done

# Process Ubuntu
for IP in "${UBUNTU_HOSTS[@]}"; do
    configure_sudo "$IP" "zach ALL=(ALL) ALL"
done

echo -e "${PURPLE}All tasks completed.${NC}"
