# --- package configuration settings ---
# --- Debian - Trixie ---
#
# PKGS_BASE includes packages for:
#	- linux kernel
#	- cli utilities
#	- networking tools
#	- optional web browser
#	- optional remote system management
#	- optional advanced cli utilities
#
# PKGS_CONSOLE includes packages for:
#   - PKGS_BASE
#	- graphics
#	- display manager
#	- native steam client
#	- steam device support
#	- 32 bit library support
#	- console system performance
#	- optional bluray support packages
#	- other optional packages
#
# PKGS_DESKTOP includes packages for:
#	- PKGS_BASE
#	- graphics
#	- full desktop environment
#	- optional office suite
#	- optional bluray support packages
#
### BEGIN PROFILE PACKAGE GROUPS: ###

# --- Define base profile packages ---
PKGS_BASE := $(PKGS_LINUX) $(PKGS_UTIL_CLI)
PKGS_BASE += $(PKGS_NET_CLI)
PKGS_BASE += $(PKGS_ADMIN_COCKPIT)
# Define advanced base utilites:
PKGS_BASE += $(PKGS_ADVANCED)
# Define base web browser:
PKGS_BASE += $(PKGS_BROWSER)

# --- Define desktop profile packages ---
PKGS_DESKTOP := $(PKGS_BASE)
# Define desktop graphics:
PKGS_DESKTOP += $(PKGS_GPU)
# Define console session:
PKGS_DESKTOP += $(PKGS_SESSION)
# Define desktop environment:
PKGS_DESKTOP += $(PKGS_DE)
# Define desktop web browser:
PKGS_DESKTOP += $(PKGS_BROWSER)
# Define desktop media:
PKGS_DESKTOP += $(PKGS_BLURAY)
# Define desktop office suite:
PKGS_DESKTOP += $(PKGS_OFFICE)

# --- Define console profile packages ---
PKGS_CONSOLE := $(PKGS_BASE)
# Define console graphics:
PKGS_CONSOLE += $(PKGS_GPU) $(PKGS_GPU32)
# Define console session:
PKGS_CONSOLE += $(PKGS_X11)
# Define console environment:
PKGS_CONSOLE += $(PKGS_STEAM)
PKGS_CONSOLE += $(PKGS_DM_SDDM)
PKGS_CONSOLE += $(PKGS_LINUX_PERF)
# Define console media:
PKGS_CONSOLE += $(PKGS_BLURAY)
# Define additional console applications:
PKGS_CONSOLE += $(PKGS_OPT)

### END PROFILE PACKAGE GROUPS. ###
### START PACKAGE GROUPS: ###

# --- Linux & Firmware ---
PKGS_LINUX := linux-image-amd64
PKGS_LINUX += linux-headers-amd64
PKGS_LINUX += firmware-iwlwifi
PKGS_LINUX += firmware-realtek
PKGS_LINUX += firmware-misc-nonfree

# --- Base Utilities ---
PKGS_UTIL_CLI := wget curl sudo
PKGS_UTIL_CLI += git
PKGS_UTIL_CLI += tuned

# --- Advanced Utilities ---
PKGS_ADVANCED_CLI := i2c-tools
PKGS_ADVANCED_CLI += python3-pip

# --- Networking Utilities ---
PKGS_NET_CLI := network-manager
PKGS_NET_CLI += iptables

# --- Administrative Applications ---
PKGS_ADMIN_COCKPIT := cockpit cockpit-storaged

# --- Session ---

## X (Xorg)
PKGS_X11 := xserver-xorg xserver-xorg-core xinit

## Wayland
PKGS_WAYLAND := # Got wayland?

# --- Graphics ---

## Hardware/Video Graphics acceleration
PKGS_ACCEL_COMMON := vainfo mesa-va-drivers mesa-vdpau-drivers

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

# --- Display Manager ---

## GNOME Display Manager
PKGS_DM_GDM := gdm3

## SDDM Display Manager
PKGS_DM_SDDM := sddm

## Light Display Manager
PKGS_DM_LIGHT := lightdm

# --- Desktop ---

## GNOME Desktop (WIP)
PKGS_DE_GNOME := gnome-core
PKGS_GNOME := $(PKGS_DM_GDM) $(PKGS_DE_GNOME)
PKGS_GNOME += $(PKGS_DESKTOP_GTERM)

## KDE Plasma Desktop (WIP)
PKGS_DE_PLASMA := kde-plasma-desktop
PKGS_PLASMA := $(PKGS_DE_PLASMA) $(PKGS_DM_SDDM)
PKGS_PLASMA += $(PKGS_DESKTOP_KTERM)

## I3 (Minimal tiling) Desktop (WIP)
##  * (i3-gaps is "i3" in Debian; suckless dwm is source-based.)
##  * (For now, ships i3 + light DM for a usable minimal desktop.)
PKGS_DE_I3 := i3 i3status dmenu xterm
PKGS_I3 := $(PKGS_DE_I3) $(PKGS_DM_LIGHT)
PKGS_I3 += $(PKGS_DESKTOP_XTERM)

# --- Desktop Applications ---

# --- Media (Audio-Video) Applications ---

## VLC Media Player
PKGS_DESKTOP_MEDIA_VLC := vlc

# --- Media (Audio-Video) Utilities ---

## DVD-Bluray (support)
PKGS_DESKTOP_MEDIA_BLURAY := libaacs0 libbdplus0

# --- Office Applications ---

## Libre Office
PKGS_DESKTOP_OFFICE_LIBRE := libreoffice
PKGS_DESKTOP_OFFICE_LIBRE_GTK := libreoffice-gtk3

# --- Utility Applications ---

## GNOME Terminal
PKGS_DESKTOP_GTERM := gnome-terminal

## Konsole Terminal
PKGS_DESKTOP_KTERM := konsole

## XTerm Terminal
PKGS_DESKTOP_XTERM := xterm

# --- WWW Browser Applications ---

## Firefox
PKGS_BROWSER_FIREFOX := firefox

## Chrome
PKGS_BROWSER_CHROME := chromium

## Elinks (CLI)
PKGS_BROWSER_ELINKS := elinks

# --- Console ---

## Steam
PKGS_CONSOLE_STEAM := steam-installer
PKGS_CONSOLE_STEAM += steam-devices
PKGS_CONSOLE_STEAM += gamemode

## Vulkan
PKGS_CONSOLE_VULKAN := vulkan-tools libvulkan1
PKGS_CONSOLE_VULKAN32 := libvulkan1:i386

# --- Console Applications ---

## Mangohud
PKGS_CONSOLE_MANGO := mangohud

# --- Console Utilities ---

## ?
PKGS_CONSOLE_UTILITIES := # Got console utilities?

# --- Performance Utilities ---

## Kernel performance
PKGS_LINUX_PERF := linux-cpupower
PKGS_LINUX_PERF += irqbalance

### END PACKAGE GROUPS. ###

# --- (Dummy package) ---
PKGS_NONE := $(PKGS_BASE)

