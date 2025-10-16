#!/bin/bash
# DVWA Auto-Installer
# Usage: wget -O - https://raw.githubusercontent.com/SQUIDOUKEN/dvwa-installer/main/install.sh | bash

set -e

REPO_URL="https://raw.githubusercontent.com/SQUIDOUKEN/dvwa-installer/main"
PORT=${PORT:-4040}

echo "DVWA Auto-Installer"
echo "Installing DVWA on port $PORT"

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/kali-version ]; then
            echo "kali"
        else
            echo "linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        echo "windows"
    else
        echo "unknown"
    fi
}

OS=$(detect_os)
echo "🖥️️ ️️  Detected OS: $OS"

case $OS in
    "linux"|"kali")
        echo "Downloading Linux installer..."
        wget -O - "$REPO_URL/scripts/install-linux.sh" | bash -s -- $PORT
        ;;
    "macos")
        echo "Downloading macOS installer..."
        curl -fsSL "$REPO_URL/scripts/install-macos.sh" | bash -s -- $PORT
        ;;
    "windows")
        echo "Please run the Windows installer manually:"
        echo "powershell -ExecutionPolicy Bypass -Command \"iwr -useb '$REPO_URL/scripts/install-windows.ps1' | iex\""
        ;;
    *)
        echo "Unsupported OS. Please install manually."
        exit 1
        ;;
esac
