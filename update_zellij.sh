#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "--- 1. Downloading the latest Zellij release ---"
curl -L -o zellij.tar.gz "https://github.com/zellij-org/zellij/releases/latest/download/zellij-no-web-x86_64-unknown-linux-musl.tar.gz"

echo "--- 2. Verifying download ---"
ls -lh zellij.tar.gz

echo "--- 3. Extracting archive ---"
tar -xzf zellij.tar.gz

echo "--- 4. Making the binary executable ---"
chmod +x zellij

echo "--- 5. Removing existing Zellij installation ---"
if [ -f /usr/local/bin/zellij ]; then
    echo "Found existing installation at /usr/local/bin/zellij. Removing it..."
    sudo rm /usr/local/bin/zellij
else
    echo "No existing installation found at /usr/local/bin/zellij."
fi

echo "--- 6. Moving new binary to /usr/local/bin/ ---"
sudo mv zellij /usr/local/bin/

echo "--- 7. Cleaning up archive ---"
rm zellij.tar.gz

echo "--- Done! Zellij has been updated successfully. ---"
zellij --version