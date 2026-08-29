# --- desktop configuration settings ---

# --- Name the ISO ---
OUTPUT_ISO := debian-alienx-desktop-autoinst.iso

# --- Name the bootloader menu entry ---
GRUB_ENTRY := ALIENWARE X51 R3 - DESKTOP - AUTOMATED RECOVERY - (PRESEED) - (PLAYBOOK)

# --- Define graphics ---
#
# *GRAPHICS* options:
#
#	- amd
#	- intel
#	- nvidia
#
GRAPHICS ?= nvidia

# --- Define session ---
#
# *SESSION* options:
#
#	- wayland
#	- x11
#
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

# --- Define www browser support ---
#
# *BROWSER* options are:
#
#	- chrome
#	- firefox
#
BROWSER ?= firefox

# --- Define office support ---
#
# *OFFICE* options:
#
#	- libre
#	- none
#
OFFICE ?= libre

# --- Define bluray/dvd support ---
#
# *BLURAY* options are boolean:
#
#	- false
#	- true
#
# (Supply a KEYDB.cfg file)
#
BLURAY ?= false


# --- Define www console support
#
# WWW admin console:
#
# *COCKPIT* options:
#
#   - false
#   - true
#
COCKPIT ?= true

# WWW admin console port:
#
# *COCKPIT_PORT* options:
#
#   - Any (reasonable) port i want
#
COCKPIT_PORT ?= 9090

# --- Define desktop package selection configuration ---
#
# PKGS selection options are:
#
#	- $(PKGS_BASE)
#	- $(PKGS_DESKTOP)
#	- $(PKGS_CONSOLE)
#
PKGS := $(PKGS_DESKTOP)
