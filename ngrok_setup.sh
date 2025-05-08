#!/bin/bash
# Ngrok Installer for Multiple Architectures

ARCH=$(uname -m)
case $ARCH in
    "armv7l") URL="https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm.tgz" ;;
    "aarch64") URL="https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm64.tgz" ;;
    "x86_64") URL="https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz" ;;
    *) echo "Unsupported architecture"; exit 1 ;;
esac

wget $URL -O ngrok.tgz
tar xzf ngrok.tgz
rm ngrok.tgz
chmod +x ngrok
