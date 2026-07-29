# package configuration settings

PKGS :=

# Kernel Firmware
PKGS += linux-headers-amd64 
PKGS += firmware-iwlwifi
PKGS += firmware-realtek
PKGS += firmware-misc-nonfree

# Utilities
PKGS += network-manager
PKGS += wget
PKGS += curl
PKGS += git
PKGS += sudo
PKGS += iptables 

# Desktop
PKGS += xserver-xorg
PKGS += kde-plasma-desktop

# Gaming
PKGS += gamemode

# Alienware
PKGS += tuned
PKGS += i2c-tools
PKGS += python3-pip

# Cockpit (web console)
PKGS += cockpit
PKGS += cockpit-storaged
