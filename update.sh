#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# ==============================================================================
# CONFIGURATION & COLORS
# ==============================================================================
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
RED="\033[1;31m"
RESET="\033[0m"

echo -e "${BLUE}========================================= ${RESET}"
echo -e "${BLUE}    System Maintenance & Update Suite     ${RESET}"
echo -e "${BLUE}========================================= ${RESET}"

# ==============================================================================
# 1. SYSTEM OS PACKAGES (NALA)
# ==============================================================================
update_system() {
    echo -e "\n${YELLOW}---> [1/3] Starting System OS Update <---${RESET}"
    
    if ! command -v nala &> /dev/null; then
        echo -e "${RED}Error: 'nala' is not installed. Skipping system update.${RESET}"
        return
    fi

    echo -e "${YELLOW}[*] Updating package lists...${RESET}"
    sudo nala update

    echo -e "${YELLOW}[*] Upgrading installed packages...${RESET}"
    sudo nala upgrade -y

    echo -e "${GREEN}[+] System update and upgrade complete!${RESET}"
}

# ==============================================================================
# 2. BTOP UPDATER
# ==============================================================================
update_btop() {
    echo -e "\n${YELLOW}---> [2/3] Starting btop Update <---${RESET}"

    # Clean up any previous installations
    if command -v btop &> /dev/null; then
        echo -e "${YELLOW}[*] Previous btop installation detected at $(which btop). Removing old binary...${RESET}"
        sudo rm -f "$(command -v btop)"

        if [ -d "/usr/local/share/btop" ]; then
            sudo rm -rf /usr/local/share/btop
        fi
    else
        echo -e "${GREEN}[*] No previous btop installation found. Proceeding with clean install.${RESET}"
    fi

    # Create temporary directory
    TEMP_DIR=$(mktemp -d)
    OLD_PWD=$(pwd)
    cd "$TEMP_DIR"
    echo -e "${YELLOW}[*] Created temporary directory at $TEMP_DIR${RESET}"

    # Fetch latest release tag
    echo -e "${YELLOW}[*] Checking GitHub for the latest btop version...${RESET}"
    LATEST_TAG=$(curl -s https://api.github.com/repos/aristocratos/btop/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

    if [ -z "$LATEST_TAG" ]; then
        echo -e "${RED}[!] Error: Could not fetch the latest version tag from GitHub for btop.${RESET}"
        cd "$OLD_PWD"
        return 1
    fi
    echo -e "${GREEN}[+] Found latest btop version: $LATEST_TAG${RESET}"

    # Download
    BINARY_URL="https://github.com/aristocratos/btop/releases/download/${LATEST_TAG}/btop-x86_64-unknown-linux-musl.tar.gz"
    echo -e "${YELLOW}[*] Downloading: $BINARY_URL${RESET}"
    curl -L -O "$BINARY_URL"

    # Extract and Install
    echo -e "${YELLOW}[*] Extracting package...${RESET}"
    tar -xf btop-x86_64-unknown-linux-musl.tar.gz
    cd btop

    echo -e "${YELLOW}[*] Installing btop to system...${RESET}"
    sudo make install

    # Setcaps for power tracking
    echo -e "${YELLOW}[*] Setting capabilities for CPU power tracking...${RESET}"
    sudo make setcap

    # Clean up
    cd "$OLD_PWD"
    rm -rf "$TEMP_DIR"

    echo -e "${GREEN}[+] Success! btop ${LATEST_TAG} has been installed.${RESET}"
}

# ==============================================================================
# 3. ZELLIJ UPDATER
# ==============================================================================
update_zellij() {
    echo -e "\n${YELLOW}---> [3/3] Starting Zellij Update <---${RESET}"

    TEMP_DIR=$(mktemp -d)
    OLD_PWD=$(pwd)
    cd "$TEMP_DIR"

    echo -e "${YELLOW}[*] Downloading the latest Zellij release...${RESET}"
    curl -L -o zellij.tar.gz "https://github.com/zellij-org/zellij/releases/latest/download/zellij-no-web-x86_64-unknown-linux-musl.tar.gz"

    echo -e "${YELLOW}[*] Verifying download size...${RESET}"
    ls -lh zellij.tar.gz

    echo -e "${YELLOW}[*] Extracting archive...${RESET}"
    tar -xzf zellij.tar.gz

    echo -e "${YELLOW}[*] Making the binary executable...${RESET}"
    chmod +x zellij

    echo -e "${YELLOW}[*] Checking for existing Zellij installation...${RESET}"
    if [ -f /usr/local/bin/zellij ]; then
        echo -e "${YELLOW}[*] Found existing installation at /usr/local/bin/zellij. Removing it...${RESET}"
        sudo rm /usr/local/bin/zellij
    else
        echo -e "${GREEN}[*] No existing installation found at /usr/local/bin/zellij.${RESET}"
    fi

    echo -e "${YELLOW}[*] Moving new binary to /usr/local/bin/...${RESET}"
    sudo mv zellij /usr/local/bin/

    # Clean up
    cd "$OLD_PWD"
    rm -rf "$TEMP_DIR"

    echo -e "${GREEN}[+] Done! Zellij version $(${MACOS_OR_LINUX:-/usr/local/bin/zellij} --version) has been updated successfully.${RESET}"
}

# ==============================================================================
# EXECUTION
# ==============================================================================
update_system
update_btop
update_zellij

echo -e "\n${BLUE}========================================= ${RESET}"
echo -e "${GREEN}   All updates completed successfully!    ${RESET}"
echo -e "${BLUE}========================================= ${RESET}"
