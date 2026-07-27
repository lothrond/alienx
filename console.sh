#!/bin/bash
# ==============================================================================
# console.sh - Native SteamOS Console Mode Build Wrapper
#
# Instructions:
# Edit the variables below to match your hardware and network setup. 
# Save the file and run `./console.sh` (or `bash console.sh`) to build the ISO.
# ==============================================================================

# Hardware Profiling
CPU_VENDOR="intel"           # Options: intel, amd
GPU_VENDOR="nvidia-maxwell"  # Options: nvidia-maxwell, amd

# Network Credentials
WIFI_SSID="MyWifi"
WIFI_PASS="Secret123"

# System Passwords
ADMIN_PASS="securepass"
GAMER_PASS="gamer"           # Used for initial PAM setup; stripped post-install for autologin

# Remote Management Web UI Port
COCKPIT_PORT="8443"

# Partitioning Scheme (Options: auto, home, multi)
PART_SCHEME="multi"

echo "=> Launching Makefile to build Native Console ISO..."
make gaming repack \
    CPU_VENDOR="${CPU_VENDOR}" \
    GPU_VENDOR="${GPU_VENDOR}" \
    WIFI_SSID="${WIFI_SSID}" \
    WIFI_PASS="${WIFI_PASS}" \
    ADMIN_PASS="${ADMIN_PASS}" \
    GAMER_PASS="${GAMER_PASS}" \
    COCKPIT_PORT="${COCKPIT_PORT}" \
    PART="${PART_SCHEME}"