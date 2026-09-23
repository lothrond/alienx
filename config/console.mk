# --- console configuration settings ---

# --- Name the ISO ---
OUTPUT_ISO := debian-alienx-console-autoinst.iso

# --- Name the bootloader menu entry ---
GRUB_ENTRY := ALIENWARE X51 R3 - CONSOLE - AUTOMATED RECOVERY - (PRESEED) - (PLAYBOOK)

# --- Define native console gaming (steam) support ---
NATIVE_STEAM := true

# --- Define console graphics ---
#
# *GRAPHICS* options are:
#
#	* amd
#   * intel
#	* nvidia
#
# *SESSION* options are:
#
#	* wayland
#	* x11
#
GRAPHICS ?= nvidia
SESSION ?= x11

# --- Define GameMode support ---
#
# *GAMEMODE_ENABLED* options:
#
#	* false
#	* true
#
# *GAMEMODE_IOPRIO* options:
#
#	* 0
#	* 1
#
# *GAMEMODE_RENICE* options:
#
#	* -10 - 10
#
# *GAMEMODE_SOFTREALTIME* options:
#
#	* auto
#	* false
#	* true
#
# *GAMEMODE_INHIBIT_SCREENSAVER := 1
#
#	* 0
#	* 1
#
GAMEMODE_ENABLED             ?= true
GAMEMODE_IOPRIO              := 0
GAMEMODE_RENICE              := 10
GAMEMODE_SOFTREALTIME        ?= auto
GAMEMODE_INHIBIT_SCREENSAVER := 1

# -- Define Proton Glorious Eggroll support ---
# WIP
#
# *PROTON_GE* options:
#
# 	* no (No)
#	* yes (Yes)
#
PROTON_GE ?= no

# -- Define Decky Loader suppport --
# WIP
#
# *DECKY* options:
#
#	* no (No)
#	* yes (Yes)
#
DECKY ?= no

# --- Define Overlay (Mangohud) support ---
MANGOHUD_ENABLED ?= true

# --- Define console CPU performance ---
#
# ArchWiki (Improving performance): irqbalance can redistribute IRQs away
# from the core handling a game's interrupts and cause stutter. Off by
# default for a console/gaming target; the package installs either way
# (packages.mk), this only controls whether the service is enabled.
#
# *CPU_IRQBALANCE_ENABLED* options:
#
#	* false
#	* true
#
CPU_IRQBALANCE_ENABLED ?= false
