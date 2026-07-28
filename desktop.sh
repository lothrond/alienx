#!/bin/bash
echo "Starting Debian 13 Trixie Desktop Build for Alienware X51 R3..."
make build \
    OUTPUT_ISO="./alienware-debian-desktop-wayland-nouveau.iso" \
    DRIVER_STACK="nouveau" \
    SESSION_TYPE="wayland" \
    BLURAY_SUPPORT="false" \
    NATIVE_STEAM="false" \
    BROWSER="firefox" \
    WIFI_SSID="MyHomeNetwork" \
    WIFI_PASS="SuperSecretPassword" \
    ROOT_PASSWORD="rootpassword123"