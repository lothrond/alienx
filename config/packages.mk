# --- package configuration settings ---

# PKGS_BASE includes packages for:
#	- linux kernel
#	- utilities
#
# PKGS_CONSOLE includes packages for:
#	- PKGS_DESKTOP
#	- native steam client
#	- steam device support
#	- system performance
#	- remote system management
#
# PKGS_DESKTOP includes packages for:
#	- PKGS_BASE
#	- graphics drivers
#	- display manager
#	- desktop environment
#
PKGS_BASE := $(PKGS_LINUX) $(PKGS_UTILS)
PKGS_DESKTOP := $(PKGS_BASE) $(PKGS_GFX) $(PKGS_GFX_ACCEL) $(PKGS_X) $(PKGS_DE)
PKGS_CONSOLE := $(PKGS_DESKTOP) $(PKGS_GAMING) $(PKGS_ALIEN) $(PKGS_COCKPIT)

# --- Kernel & Firmware ---
PKGS_LINUX := linux-amd64
PKGS_LINUX += linux-headers-amd64 
PKGS_LINUX += firmware-iwlwifi
PKGS_LINUX += firmware-realtek
PKGS_LINUX += firmware-misc-nonfree

# --- Utilities ---
PKGS_UTILS := network-manager
PKGS_UTILS += wget
PKGS_UTILS += curl
PKGS_UTILS += git
PKGS_UTILS += sudo
PKGS_UTILS += iptables 

# --- Desktop ---
PKGS_X := xserver-xorg
PKGS_DE := kde-plasma-desktop

# --- Graphics ---
PKGS_GFX := $(PKGS_GFX_NVIDIA)
PKGS_GFX_CONSOLE := $(PKGS_GFX) $(PKGS_GFX_ACCEL)
PKGS_GFX_DESKTOP := $(PKGS_GFX)

# --- Hardware/Video acceleration ---
PKGS_GFX_ACCEL := $(PKGS_GFX_ACCEL_INTEL)

## Intel
PKGS_GFX_ACCEL_INTEL := intel-media-va-driver-non-free
PKGS_GFX_ACCEL_INTEL += firmware-intel-graphics

# --- Gaming ---
PKGS_GAMING := gamemode
PKGS_GAMING += tuned 

# --- Alienware ---
PKGS_ALIEN := i2c-tools
PKGS_ALIEN += python3-pip

# --- Cockpit (web console) ---
PKGS_COCKPIT := cockpit
PKGS_COCKPIT += cockpit-storaged
