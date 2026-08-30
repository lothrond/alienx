# --- package configuration settings ---
# --- Debian - Trixie ---
#
#
# PKGS_BASE includes packages for:
#	- linux kernel
#	- utilities
#	- remote system management
#
# PKGS_CONSOLE includes packages for:
#   - PKGS_BASE
#	- graphics drivers (DRIVER_STACK)
#	- native steam client
#	- display manager
#	- steam device support
#	- 32 bit library support
#	- console system performance
#	- gaming/performance tuning (config/gaming.mk)
#
# PKGS_DESKTOP includes packages for:
#	- PKGS_BASE
#	- graphics drivers (DRIVER_STACK)
#	- desktop environment
#	- display manager
#	- desktop system performance
#
#
# --- Profile Package Groups ---

# base
PKGS_BASE := $(PKGS_LINUX) $(PKGS_UTIL_CLI)
PKGS_BASE += $(PKGS_ADV_CLI)
PKGS_VASE += $(PKGS_NET_CLI)
PKGS_BASE += $(PKGS_BROWSER)

# desktop
PKGS_DESKTOP := $(PKGS_BASE)
PKGS_DESKTOP += $(PKGS_GPU)
PKGS_DESKTOP += $(PKGS_DE)
PKGS_DESKTOP += $(PKGS_BROWSER)
PKGS_DESKTOP += $(PKGS_BLURAY)
PKGS_DESKTOP += $(PKGS_OFFICE)

# console
PKGS_CONSOLE := $(PKGS_BASE)
PKGS_CONSOLE += $(PKGS_GPU) $(PKGS_GPU32)
PKGS_CONSOLE += $(PKGS_X11)
PKGS_CONSOLE += $(PKGS_DM_PLASMA)
PKGS_CONSOLE += $(PKGS_STEAM)
PKGS_CONSOLE += $(PKGS_GAMING_PERF)
PKGS_CONSOLE += $(PKGS_DESKTOP)
PKGS_CONSOLE += $(PKGS_BLURAY)

# --- Linux & Firmware ---
PKGS_LINUX := linux-image-amd64
PKGS_LINUX += linux-headers-amd64
PKGS_LINUX += firmware-iwlwifi
PKGS_LINUX += firmware-realtek
PKGS_LINUX += firmware-misc-nonfree

# --- Base (CLI) Utilities ---
PKGS_UTIL_CLI := wget curl sudo
PKGS_UTIL_CLI += git
PKGS_UTIL_CLI += tuned

# --- Advanced (CLI) Utilities ---
PKGS_ADV_CLI := i2c-tools python3-pip

# --- Networking (CLI) ---
PKGS_NET_CLI := network-manager
PKGS_NET_CLI += iptables

# --- WWW Console (cockpit) ---
PKGS_COCKPIT := cockpit cockpit-storaged

# --- DVD-Bluray ---
PKGS_BLURAY := vlc libaacs0 libbdplus0

# --- X (Xorg) ---
PKGS_X11 := xserver-xorg xserver-xorg-core xinit

# --- Hardware/Video Graphics acceleration ---
PKGS_ACCEL_COMMON := vainfo mesa-va-drivers mesa-vdpau-drivers

# --- Graphics driver stacks ---

## Nvidia – Maxwell (GTX 745/960/970)
##
## - Tesla 470 is the Maxwell/Kepler branch.
## - On Trixie, if nvidia-tesla-470-* is missing from the mirror,
##   switch these to:
##   - nvidia-driver
##   - nvidia-driver-libs:i386
##
## (550 still lists Maxwell support).
PKGS_NVIDIA := nvidia-tesla-470-driver
PKGS_NVIDIA += xserver-xorg-video-nvidia-tesla-470
PKGS_NVIDIA += nvidia-tesla-470-vulkan-icd
PKGS_NVIDIA += nvidia-tesla-470-vdpau-driver
PKGS_NVIDIA32 := nvidia-tesla-470-driver-libs:i386
PKGS_NVIDIA32 += libnvidia-gl-470:i386
PKGS_NVIDIA_ACCEL := $(PKGS_ACCEL_COMMON)

## AMD – generic modern stack (amdgpu + Mesa)
## (Edit when i find exact GPU (GCN / RDNA generation).)
PKGS_AMD := firmware-amd-graphics
PKGS_AMD += xserver-xorg-video-amdgpu
PKGS_AMD += mesa-vulkan-drivers
PKGS_AMD += libgl1-mesa-dri
PKGS_AMD32 := mesa-vulkan-drivers:i386
PKGS_AMD32 += libgl1-mesa-dri:i386
PKGS_AMD_ACCEL := $(PKGS_ACCEL_COMMON)

## Intel – Skylake-class iGPU (HD 530 etc.)
## (And similar GEN9+)
PKGS_INTEL := firmware-intel-graphics
PKGS_INTEL += xserver-xorg-video-intel
PKGS_INTEL += mesa-vulkan-drivers
PKGS_INTEL += libgl1-mesa-dri
PKGS_INTEL += intel-media-va-driver-non-free
PKGS_INTEL32 := mesa-vulkan-drivers:i386
PKGS_INTEL32 += libgl1-mesa-dri:i386
PKGS_INTEL_ACCEL := $(PKGS_ACCEL_COMMON)
PKGS_INTEL_ACCEL += intel-media-va-driver-non-free

# Vulkan
PKGS_CONSOLE_VULKAN := vulkan-tools libvulkan1
PKGS_CONSOLE_VULKAN32 := libvulkan1:i386

# --- WWW Browsers ---

## Firefox
PKGS_BROWSER_FIREFOX := firefox

## Chrome
PKGS_BROWSER_CHROME  := chromium

## Elinks
PKGS_BROWSER_ELINKS  := elinks

# --- Office ---

## Libre Office
PKGS_OFFICE_LIBRE := libreoffice
PKGS_OFFICE_LIBRE_GTK := libreoffice-gtk3

# -- Desktop environment ---

## KDE Plasma Desktop
PKGS_PLASMA := kde-plasma-desktop
PKGS_DM_PLASMA := sddm

## GNOME Desktop
PKGS_GNOME := gnome-core
PKGS_DM_GNOME := gdm3

## I3 (Minimal tiling) Desktop
##  * (i3-gaps is "i3" in Debian; suckless dwm is source-based.)
##  * (For now, ships i3 + light DM for a usable minimal desktop.)
PKGS_I3 := i3 i3status dmenu xterm
PKGS_DM_I3 := lightdm

# --- Console environment ---

## Steam
PKGS_STEAM := steam-installer
PKGS_STEAM += steam-devices
PKGS_STEAM += gamemode

## Performance tuning
PKGS_CONSOLE_PERF := linux-cpupower
PKGS_CONSOLE_PERF += irqbalance

## Mangohud
PKGS_CONSOLE_MANGO := mangohud

# --- Dummy package ---
PKGS_NONE := $(PKGS_BASE)
