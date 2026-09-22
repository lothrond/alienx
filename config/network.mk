# --- network configuration settings ---

# --- Firewall ---
#
# *FIREWALL* options:
#
#	- false
#	- true
#
FIREWALL ?= true

# --- WIFI ---
#
# *WIFI_SSID*
#
#	- WIFI network goes here.
#
# *WIFI_PASS*
#
#	- WIFI password goes here.
#
WIFI_SSID ?= MyHomeNetwork
WIFI_PASS ?= SuperSecretPasswordYes

# --- Define www console support ---
#
# www admin console:
#
# *COCKPIT* options:
#
#   * no (No)
#   * yes (Yes)
#
COCKPIT ?= yes

# WWW admin console port:
#
# *COCKPIT_PORT* options:
#
#   * Any (reasonable) port i want
#
COCKPIT_PORT ?= 9090
