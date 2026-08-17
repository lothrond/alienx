# --- system configuration settings ---

# --- Hostname ---
LOCAL_HOST := alienware-x51-r3

# -- Language settings --
# (Defaults to english US)
LOCAL_LANG := en_US.UTF-8

# -- Keyboad keymap --
## (Defaults to english US)
LOCAL_KMAP := us

# -- Timezone --
LOCAL_TZ := UTC

# --- Define Cockpit (Server with GUI) ---
#
# *COCKPIT_ENABLED* options:
#
#	- false
#	- true
#
COCKPIT_ENABLED ?= true

# *COCKPIT_PORT*:
#
#	- any (reasonable) port i want
#
COCKPIT_PORT ?= 9090