# --- system configuration settings ---

# Define Hostname:
#
# *LOCAL_HOST*
#
#	- (some hostname)
#
LOCAL_HOST := alienware-x51-r3

# Define Language settings:
#
# *LOCAL_LANG*
#
#	- (Defaults to english US)
#
LOCAL_LANG := en_US.UTF-8

# Define Keyboad keymap:
#
# *LOCAL_KMAP*
#
#	- (Defaults to english US)
#
LOCAL_KMAP := us

# Define Timezone:
#
# *LOCAL_TZ*
#
#	- (Defaults to utc)
#
LOCAL_TZ := UTC

# WWW Console (Cockpit):
#
# *COCKPIT_ENABLED* options:
#
#	- false
#	- true
#
COCKPIT_ENABLED ?= true

# WWW Console (Cockpit) port:
#
# *COCKPIT_PORT* options:
#
#	- any (reasonable) port i want
#
COCKPIT_PORT ?= 9090
