# --- disk device configuration settings ---

DEVICE ?= /dev/sda

## Device partition type
#
# PARTS options are:
#	- auto
#	- home
#	- multi
#	- regular
#
PARTS ?= regular