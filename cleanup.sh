#!/bin/bash
# Log Cleaner with Security

rm -rf logs/*
find . -name "*.log" -exec rm -f {} \;
pkill -f "php -S"
pkill -f "ngrok"
pkill -f "cloudflared"
