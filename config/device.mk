# --- disk device configuration settings ---

# --- Define device ---
DEVICE ?= /dev/sda

# --- Define device partitions ---
#
# *PARTS* options:
#
#	- auto
#	- home
#	- multi
#	- regular
#
PARTS ?= regular