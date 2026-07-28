#!/bin/bash
echo "Starting Debian 13 Trixie Console Build for Alienware X51 R3..."
make build \
    OUTPUT_ISO="./alienware-debian-console-x11-nvidia.iso" \
    DRIVER_STACK="nvidia" \
    SESSION_TYPE="x11" \
    BLURAY_SUPPORT="true" \
    NATIVE_STEAM="true" \
    BROWSER="chrome" \
    WIFI_SSID="MyHomeNetwork" \
    WIFI_PASS="SuperSecretPassword" \
    ROOT_PASSWORD="rootpassword123" \
    USER_PASSWORD="userpassword123"