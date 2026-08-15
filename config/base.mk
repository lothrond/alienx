# --- base system profile defaults ---

# --- Name the ISO: ---
OUTPUT_ISO := ./alienware-debian-base.iso

# --- Name the bootloader entry: ---
GRUB_ENTRY := ALIENWARE X51 R3 - BASE/SERVER - AUTOMATED RECOVERY (PRESEED)

# --- Define application support ---

# *BROWSER* options:
#
# 	- elinks
#	- none
#
BROWSER := none

# --- Define Cockpit (Server with GUI) ---
#
# *COCKPIT_ENABLED* options:
#
#	- false
#	- true
COCKPIT_ENABLED := true

# *COCKPIT_PORT*:
#
#	- any (reasonable) port i want
#
COCKPIT_PORT := 9090