# --- desktop configuration settings ---

# --- Name the ISO ---
#
# OUPUT_ISO is a string:
#	- Any thing i want goes here.
#
OUTPUT_ISO := ./alienware-debian-desktop-netinst.iso

# -- Name the bootloader menu entry ---
#
# GRUB_ENTRY is a string:
#	- Any thing i want goes here.
#
GRUB_ENTRY := ALIENWARE X51 R3 - DESKTOP - AUTOMATED RECOVERY (PRESEED)

# --- Define graphics settings ---
#
# DRIVER_STACK options are:
#	- nouveau
#	- nvidia
#
# SESSION_TYPE options are:
#	- wayland
#	- x11
#
DRIVER_STACK := nouveau
SESSION_TYPE := wayland

# --- Define application support ---
#
# BLURAY_SUPPORT options are boolean:
#	- false
#	- true
#
# NATIVE_STEAM options are boolean:
#	- false
#	- true
#
# BROWSER options are:
#	- chrome
#	- firefox
#	- elinks
#
BLURAY_SUPPORT := false
NATIVE_STEAM := false
BROWSER := firefox

# --- Define package selection ---
#
# PKGS selection options are:
#
#	- $(PKGS_BASE)
#	- $(PKGS_DESKTOP)
#	- $(PKGS_CONSOLE)
#
PKGS := $(PKGS_DESKTOP)

# --- Define user account settings ---
#
# ROOT_PASSWORD is a string:
#	- Any thing i want goes here.
#
# USER_PASSWORD is a string:
#	- Any thing i want goes here.
# 
ROOT_PASSWORD := rootpassword123
USER_PASSWORD := userpassword123

# --- Define network settings ---
#
# WIFI_SSID is a string:
#	- Any thing i want goes here.
#
# WIFI_PASS is a string:
#	- Any thing i want goes here.
#
WIFI_SSID := MyHomeNetwork
WIFI_PASS := SuperSecretPassword