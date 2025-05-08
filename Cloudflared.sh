#!/bin/bash
# Universal Cloudflared Installer
# Supports: ARMv7, ARM64, x86, x86_64
# Developed by Rayhan for CamPhish Pro
# Version: 2.0

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Detect OS and Architecture
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

# Installation Directory
INSTALL_DIR="/data/data/com.termux/files/usr/bin"

# Download URLs
declare -A CLOUDFLARED_URLS=(
    ["linux-armv7"]="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm"
    ["linux-aarch64"]="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64"
    ["linux-x86"]="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-386"
    ["linux-x86_64"]="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64"
    ["darwin-arm64"]="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-darwin-arm64"
    ["darwin-x86_64"]="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-darwin-amd64"
)

# Architecture Mapping
case "$ARCH" in
    "armv7l"|"armhf") ARCH_KEY="armv7" ;;
    "aarch64"|"arm64") ARCH_KEY="aarch64" ;;
    "i386"|"i686") ARCH_KEY="x86" ;;
    "x86_64"|"amd64") ARCH_KEY="x86_64" ;;
    *) ARCH_KEY="" ;;
esac

# Verify Support
verify_support() {
    if [ -z "${CLOUDFLARED_URLS["$OS-$ARCH_KEY"]}" ]; then
        echo -e "${RED}[-] Unsupported OS/Architecture: $OS-$ARCH${NC}"
        echo -e "${YELLOW}Supported Combinations:${NC}"
        printf "  %-15s %-15s\n" "OS" "Architecture"
        printf "  %-15s %-15s\n" "---------------" "---------------"
        for key in "${!CLOUDFLARED_URLS[@]}"; do
            IFS='-' read -r os arch <<< "$key"
            printf "  %-15s %-15s\n" "$os" "$arch"
        done
        exit 1
    fi
}

# Install Cloudflared
install_cloudflared() {
    echo -e "${BLUE}[*] Detected: $OS-$ARCH${NC}"
    echo -e "${GREEN}[+] Downloading for $ARCH_KEY architecture...${NC}"
    
    URL="${CLOUDFLARED_URLS["$OS-$ARCH_KEY"]}"
    if wget -q --show-progress "$URL" -O cloudflared; then
        chmod +x cloudflared
        
        # Install to appropriate directory
        if [[ "$OS" == "linux" && -d "$INSTALL_DIR" ]]; then
            mv cloudflared "$INSTALL_DIR" && \
            echo -e "${GREEN}[✓] Installed to: $INSTALL_DIR/cloudflared${NC}"
        else
            mkdir -p ~/.local/bin
            mv cloudflared ~/.local/bin/ && \
            echo -e "${GREEN}[✓] Installed to: ~/.local/bin/cloudflared${NC}"
            export PATH="$PATH:$HOME/.local/bin"
        fi
        
        # Verify installation
        if cloudflared --version >/dev/null 2>&1; then
            echo -e "${GREEN}[✓] $(cloudflared --version | head -n 1)${NC}"
        else
            echo -e "${RED}[-] Verification failed! Check PATH${NC}"
            exit 1
        fi
    else
        echo -e "${RED}[-] Download failed${NC}"
        exit 1
    fi
}

# Main Menu
show_menu() {
    echo -e "\n${BLUE}=== Cloudflared Universal Installer ===${NC}"
    echo -e "${YELLOW}Detected: $OS-$ARCH ($ARCH_KEY)${NC}"
    echo -e "1. Install/Reinstall"
    echo -e "2. Update"
    echo -e "3. Check Version"
    echo -e "4. Exit"
    
    read -p "Select option (1-4): " choice
    case $choice in
        1) verify_support; install_cloudflared ;;
        2) verify_support; install_cloudflared ;;
        3) 
            if command -v cloudflared >/dev/null; then
                cloudflared --version
            else
                echo -e "${RED}[-] Cloudflared not installed${NC}"
            fi
            ;;
        4) exit 0 ;;
        *) echo -e "${RED}[-] Invalid option${NC}"; exit 1 ;;
    esac
}

# Execution
verify_support
show_menu

echo -e "\n${GREEN}Usage Examples:${NC}"
echo -e "1. Start tunnel: ${BLUE}cloudflared tunnel --url http://localhost:3333${NC}"
echo -e "2. Show help: ${BLUE}cloudflared --help${NC}"
echo -e "\n${YELLOW}Note: For Termux, ensure storage permissions are granted!${NC}"
