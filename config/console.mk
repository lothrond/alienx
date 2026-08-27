# --- console configuration settings ---

# --- Name the ISO ---
OUTPUT_ISO ?= debian-alienx-console-autoinst.iso

# -- Name the ISO bootloader menu entry ---
GRUB_ENTRY ?= ALIENWARE X51 R3 - CONSOLE - AUTOMATED RECOVERY - (PRESEED) - (PLAYBOOK)

# --- Define graphics settings ---
#
# *DRIVER_STACK* options are:
#
#	- amd
#   - intel
#	- nvidia
#
DRIVER_STACK ?= nvidia

# *SESSION_TYPE* options are:
#
#	- wayland
#	- x11
#
SESSION_TYPE ?= x11

# -- Define native console gaming (steam) support ---
NATIVE_STEAM ?= true

# -- Define PROTON-GE --
# WIP
#PROTON_GE ?= false

# -- Define deck loader suppport --
# WIP
#DECKY ?= false

# --- Define application support ---
#
# *BLURAY_SUPPORT* options are boolean:
#
#	- false
#	- true
#
BLURAY_SUPPORT ?= false

# --- Define package selection ---
#
# PKGS selection options are:
#
#	- $(PKGS_BASE)
#	- $(PKGS_DESKTOP)
#	- $(PKGS_CONSOLE)
#
PKGS := $(PKGS_CONSOLE)
