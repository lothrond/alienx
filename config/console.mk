# --- console configuration settings ---

# --- Name the ISO ---
OUTPUT_ISO ?= debian-alienx-console-autoinst.iso

# --- Name the bootloader menu entry ---
GRUB_ENTRY ?= ALIENWARE X51 R3 - CONSOLE - AUTOMATED RECOVERY - (PRESEED) - (PLAYBOOK)

# --- Define graphics ---
#
# *GRAPHICS* options are:
#
#	- amd
#   - intel
#	- nvidia
#
GRAPHICS ?= nvidia

# --- Define session ---
#
# *SESSION* options are:
#
#	- wayland
#	- x11
#
SESSION ?= x11

# -- Define native console gaming (steam) support ---
NATIVE_STEAM ?= true

# -- Define Proton-GE ---
# WIP
PROTON_GE ?= false

# -- Define decky loader suppport --
# WIP
DECKY ?= false

# --- Define bluray/dvd support ---
#
# *BLURAY* options are boolean:
#
#	- false
#	- true
#
# (Supply a KEYDB.cfg)
#
BLURAY  ?= false

# --- Define www console support ---
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

# --- Define package selection ---
#
# PKGS selection options are:
#
#	- $(PKGS_BASE)
#	- $(PKGS_DESKTOP)
#	- $(PKGS_CONSOLE)
#
PKGS := $(PKGS_CONSOLE)
