#!/bin/bash
# ==============================================================================
# desktop.sh - Standard 64-Bit GNOME Desktop Build Wrapper
#
# Instructions:
# Edit the variables below to customize your network and passwords. 
# Save the file and run `./desktop.sh` (or `bash desktop.sh`) to build the ISO.
# ==============================================================================

# Network Credentials
WIFI_SSID="MyWifi"
WIFI_PASS="Secret123"

# System Passwords
ADMIN_PASS="securepass"

# Remote Management Web UI Port
COCKPIT_PORT="9090"

# Partitioning Scheme (Options: auto, home, multi)
PART_SCHEME="home"

echo "=> Launching Makefile to build Desktop ISO..."
make repack \
    WIFI_SSID="${WIFI_SSID}" \
    WIFI_PASS="${WIFI_PASS}" \
    ADMIN_PASS="${ADMIN_PASS}" \
    COCKPIT_PORT="${COCKPIT_PORT}" \
    PART="${PART_SCHEME}"