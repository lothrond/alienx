# --- desktop configuration settings ---

# --- Name the ISO ---
OUTPUT_ISO ?= debian-alienx-desktop-autoinst.iso

# Name the bootloader menu entry ---
GRUB_ENTRY ?= ALIENWARE X51 R3 - DESKTOP - AUTOMATED RECOVERY - (PRESEED) - (PLAYBOOK)

# *DRIVER_STACK* options:
#
#	- amd
#	- intel
#	- nvidia
#
DRIVER_STACK ?= nvidia

# *SESSION_TYPE* options:
#
#	- wayland
#	- x11
#
SESSION_TYPE ?= wayland

# --- Define desktop application support ---

# *BROWSER* options are:
#
#	- chrome
#	- firefox
#	- elinks
#
BROWSER ?= firefox

# *BLURAY_SUPPORT* options are boolean:
#
#	- false
#	- true
#
BLURAY_SUPPORT ?= false

# --- Define desktop ---
#
# *DESKTOP* options:
#
#	- gnome
#	- i3
#	- plasma
#
DESKTOP ?= plasma

# *OFFICE* options:
#
#	- libre
#	- none
#
OFFICE ?= none

# --- Define desktop package selection configuration ---
#
# PKGS selection options are:
#
#	- $(PKGS_BASE)
#	- $(PKGS_DESKTOP)
#	- $(PKGS_CONSOLE)
#
PKGS := $(PKGS_DESKTOP)
