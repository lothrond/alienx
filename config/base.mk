# --- base system profile defaults ---

# --- Name the ISO: ---
OUTPUT_ISO ?= debian-alienx-base-autoinst.iso

# --- Name the bootloader entry: ---
GRUB_ENTRY ?= ALIENWARE X51 R3 - BASE/SERVER - AUTOMATED RECOVERY (PRESEED)

# --- Define system configuration settings ---

# Hostname:
#
# *LOCAL_HOST*
#
#   - (some hostname)
#
LOCAL_HOST ?= alienware-x51-r3

# Language settings:
#
# *LOCAL_LANG*
#
#   - (Defaults to english US)
#
LOCAL_LANG ?= en_US.UTF-8

# Keyboad keymap:
#
# *LOCAL_KMAP*
#
#   - (Defaults to english US)
#
LOCAL_KMAP ?= us

# Timezone:
#
# *LOCAL_TZ*
#
#   - (Defaults to utc)
#
LOCAL_TZ ?= UTC

# --- Define application support ---

# WWW Browser:
#
# *BROWSER* options:
#
#   - elinks
#	- none
#
BROWSER ?= none

# --- Define WWW Console ---

# WWW admin console:
#
# *COCKPIT_ENABLED* options:
#
#   - false
#   - true
#
COCKPIT_ENABLED ?= true

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
#   - $(PKGS_BASE)
#   - $(PKGS_DESKTOP)
#   - $(PKGS_CONSOLE)
#
PKGS := $(PKGS_BASE)
