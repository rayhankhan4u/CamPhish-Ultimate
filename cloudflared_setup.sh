#!/bin/bash
# Cloudflared Installer

ARCH=$(uname -m)
URL="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-$ARCH"

wget $URL -O cloudflared
chmod +x cloudflared
