# --- desktop configuration settings ---

# --- Name the ISO ---
OUTPUT_ISO := debian-alienx-desktop-autoinst.iso

# --- Name the bootloader menu entry ---
GRUB_ENTRY := ALIENWARE X51 R3 - DESKTOP - AUTOMATED RECOVERY - (PRESEED) - (PLAYBOOK)

# --- Define desktop graphics ---
#
# *GRAPHICS* options:
#
#	- amd
#	- intel
#	- nvidia
#
# *SESSION* options:
#
#	- wayland
#	- x11
#
GRAPHICS ?= nvidia
SESSION ?= wayland

# --- Define desktop ---
#
# *DESKTOP* options:
#
#	- gnome
#	- plasma
#	- i3
#
DESKTOP ?= plasma

# --- Define office support ---
#
# *OFFICE* options:
#
#	- libre
#	- none
#
OFFICE ?= libre

# --- Define www browser support ---
#
# *BROWSER* options are:
#
#	- chrome
#	- firefox
#
BROWSER ?= firefox
