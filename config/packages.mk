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
# --- Profile Package Groups ---

## Define base profile packages:
PKGS_BASE := $(PKGS_LINUX) $(PKGS_UTIL_CLI)
PKGS_BASE += $(PKGS_ADV_CLI)
PKGS_BASE += $(PKGS_NET_CLI)
PKGS_BASE += $(PKGS_BROWSER)

## Define desktop profile packages:
PKGS_DESKTOP := $(PKGS_BASE)
PKGS_DESKTOP += $(PKGS_GPU)
PKGS_DESKTOP += $(PKGS_DE)
PKGS_DESKTOP += $(PKGS_BROWSER)
PKGS_DESKTOP += $(PKGS_BLURAY)
PKGS_DESKTOP += $(PKGS_OFFICE)

## Define console profile packages:
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

# --- Base Utilities ---
PKGS_UTIL_CLI := wget curl sudo
PKGS_UTIL_CLI += git
PKGS_UTIL_CLI += tuned

# --- Advanced Utilities ---
PKGS_ADV_CLI := i2c-tools python3-pip

# --- Networking Utilities ---
PKGS_NET_CLI := network-manager
PKGS_NET_CLI += iptables

# --- Admin Applications ---
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

# --- Desktop ---

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

# --- Desktop Applications ---

# --- Media (Audio-Video) Applications ---

## VLC Media Player
PKGS_MEDIA_VLC := vlc

# --- Media (Audio-Video) Utilities ---

## DVD-Bluray (support)
PKGS_MEDIA_BLURAY := libaacs0 libbdplus0

# --- Office Applications ---

## Libre Office
PKGS_OFFICE_LIBRE := libreoffice
PKGS_OFFICE_LIBRE_GTK := libreoffice-gtk3

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
PKGS_CONSOLE_PERF := linux-cpupower
PKGS_CONSOLE_PERF += irqbalance

# --- (Dummy package) ---
PKGS_NONE := $(PKGS_BASE)

