# --- base profile configuration settings ---

# --- Name the ISO ---
OUTPUT_ISO := debian-alienx-base-autoinst.iso

# --- Name the bootloader menu entry ---
GRUB_ENTRY := ALIENWARE X51 R3 - BASE/SERVER - AUTOMATED RECOVERY (PRESEED)

# --- Define system configuration settings ---

# Hostname:
#
# *LOCAL_HOST*
#
#   * (some hostname)
#
LOCAL_HOST ?= alienware-x51-r3

# Language settings:
#
# *LOCAL_LANG*
#
#   * (Defaults to english US)
#
LOCAL_LANG ?= en_US.UTF-8

# Keyboad keymap:
#
# *LOCAL_KMAP*
#
#   * (Defaults to english US)
#
LOCAL_KMAP ?= us

# Timezone:
#
# *LOCAL_TZ*
#
#   * (Defaults to utc)
#
LOCAL_TZ ?= UTC

# --- Define www browser support ---
#
# *BROWSER* options:
#
#   * elinks
#	* none
#
BROWSER ?= none
