#!/bin/bash

# Color Definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color (Reset)


# Define the list of hosts (IPs only)
HOSTS=(
    192.168.122.105 192.168.122.25 192.168.122.122 192.168.122.176 # Redhat
    192.168.122.141 192.168.122.213 192.168.122.61 192.168.122.242 # Ubuntu
    192.168.122.169 192.168.122.196 192.168.122.205 192.168.122.136 # Oracle
)

# User to log in as (change 'root' if needed)
REMOTE_USERNAME="zach"
SSH_KEY_PATH="/home/dutchman/.ssh/id_rsa.pub"

echo -e "${PURPLE}Starting SSH key distribution...${NC}"

for IP in "${HOSTS[@]}"; do
    echo "---------------------------------------"
    echo "Sending key to: $IP"
    
    # Copy the key. -o StrictHostKeyChecking=no skips the 'yes/no' prompt
    ssh-copy-id -i ${SSH_KEY_PATH} -o StrictHostKeyChecking=no "${REMOTE_USERNAME}@${IP}"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Success: ${IP}${NC}"
    else
        echo -e "${RED}Failed: ${IP}${NC}"
    fi
done

echo -e "${PURPLE}Finished prcessing all hosts.${NC}"
