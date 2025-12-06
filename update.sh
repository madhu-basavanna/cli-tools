#!/bin/bash

set -e

# Colors for output
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
RESET="\033[0m"

# Check if nala is installed
if ! command -v nala &> /dev/null; then
    echo -e "${RED}Error: 'nala' is not installed. Please install it first.${RESET}"
    exit 1
fi

echo -e "${YELLOW}Updating package lists...${RESET}"
sudo nala update

echo -e "${YELLOW}Upgrading installed packages...${RESET}"
sudo nala upgrade -y

echo -e "${GREEN}System update and upgrade complete!${RESET}"
