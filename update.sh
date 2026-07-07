#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# ==============================================================================
# CONFIGURATION & COLORS
# ==============================================================================
GREEN="\033[1;32m"
YELLOW="\033[1;33}m"
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
        echo -e "\n${YELLOW}---> [2/3] Checking btop Update <---${RESET}"

    # Fetch latest release tag from GitHub
    echo -e "${YELLOW}[*] Checking GitHub for the latest btop version...${RESET}"
    LATEST_TAG=$(curl -s https://api.github.com/repos/aristocratos/btop/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

    if [ -z "$LATEST_TAG" ]; then
        echo -e "${RED}[!] Error: Could not fetch the latest version tag from GitHub for btop.${RESET}"
        return 1
    fi

    # Check local version if btop is installed
    if command -v btop &> /dev/null; then
        # 'btop -v' outputs something like "btop version: 1.3.0"
        CURRENT_VERSION="v$(btop -v | awk '{print $3}')"

        echo -e "${BLUE}[*] Installed btop version: $CURRENT_VERSION${RESET}"
        echo -e "${BLUE}[*] Latest GitHub version:    $LATEST_TAG${RESET}"

        if [ "$CURRENT_VERSION" = "$LATEST_TAG" ]; then
            echo -e "${GREEN}[+] btop is already up to date. Skipping update.${RESET}"
            return 0
        fi
    else
        echo -e "${YELLOW}[*] btop is not currently installed.${RESET}"
    fi

    echo -e "${YELLOW}[*] Proceeding with btop installation/upgrade...${RESET}"

    # Clean up any previous installations
    if command -v btop &> /dev/null; then
        echo -e "${YELLOW}[*] Removing old binary...${RESET}"
        sudo rm -f "$(command -v btop)"
        if [ -d "/usr/local/share/btop" ]; then
            sudo rm -rf /usr/local/share/btop
        fi
    fi

    # Install required build dependencies
    echo -e "${YELLOW}[*] Installing build dependencies...${RESET}"
    sudo nala install -y build-essential git libgpiod-dev pkg-config

    # Create temporary directory
    TEMP_DIR=$(mktemp -d)
    OLD_PWD=$(pwd)
    cd "$TEMP_DIR"

    # Clone the repository
    echo -e "${YELLOW}[*] Cloning btop repository (${LATEST_TAG})...${RESET}"
    git clone --depth 1 --branch "$LATEST_TAG" https://github.com/aristocratos/btop.git
    cd btop

    # Build with make
    echo -e "${YELLOW}[*] Building btop...${RESET}"
    make GPU_SUPPORT=true

    # Install
    echo -e "${YELLOW}[*] Installing btop to system...${RESET}"
    sudo make install

    # Setcaps for power tracking
    echo -e "${YELLOW}[*] Setting capabilities for CPU power tracking...${RESET}"
    sudo make setcap
    sudo make setuid

    # Clean up
    cd "$OLD_PWD"
    rm -rf "$TEMP_DIR"

    echo -e "${GREEN}[+] Success! btop ${LATEST_TAG} has been installed from source.${RESET}"
}

# ==============================================================================
# 3. ZELLIJ UPDATER
# ==============================================================================
update_zellij() {
    echo -e "\n${YELLOW}---> [3/3] Checking Zellij Update <---${RESET}"

    # Fetch latest release tag from GitHub
    echo -e "${YELLOW}[*] Checking GitHub for the latest Zellij version...${RESET}"
    LATEST_TAG=$(curl -s https://api.github.com/repos/zellij-org/zellij/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

    if [ -z "$LATEST_TAG" ]; then
        echo -e "${RED}[!] Error: Could not fetch the latest version tag from GitHub for Zellij.${RESET}"
        return 1
    fi

    # Check local version if zellij is installed
    if command -v zellij &> /dev/null; then
        # 'zellij --version' outputs something like "zellij 0.40.1"
        CURRENT_VERSION="v$(zellij --version | awk '{print $2}')"

        echo -e "${BLUE}[*] Installed Zellij version: $CURRENT_VERSION${RESET}"
        echo -e "${BLUE}[*] Latest GitHub version:    $LATEST_TAG${RESET}"

        if [ "$CURRENT_VERSION" = "$LATEST_TAG" ]; then
            echo -e "${GREEN}[+] Zellij is already up to date. Skipping update.${RESET}"
            return 0
        fi
    else
        echo -e "${YELLOW}[*] Zellij is not currently installed.${RESET}"
    fi

    echo -e "${YELLOW}[*] Proceeding with Zellij installation/upgrade...${RESET}"

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
    fi

    echo -e "${YELLOW}[*] Moving new binary to /usr/local/bin/...${RESET}"
    sudo mv zellij /usr/local/bin/

    # Clean up
    cd "$OLD_PWD"
    rm -rf "$TEMP_DIR"

    echo -e "${GREEN}[+] Done! Zellij has been updated to version $LATEST_TAG.${RESET}"
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
