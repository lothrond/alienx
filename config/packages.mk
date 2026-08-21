# --- package configuration settings ---
# --- Debian - Trixie ---
#
# ---
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
# ---
#
# --- Profile Package Groups ---
PKGS_BASE := $(PKGS_LINUX) $(PKGS_UTILS) $(PKGS_COCKPIT)
PKGS_DESKTOP := $(PKGS_BASE) $(PKGS_GPU) $(PKGS_X11) $(PKGS_DE_SEL) $(PKGS_BLURAY) $(PKGS_OPT)
PKGS_CONSOLE := $(PKGS_BASE) $(PKGS_GPU) $(PKGS_GPU32) $(PKGS_X11) $(PKGS_DM_PLASMA) $(PKGS_STEAM) $(PKGS_BLURAY) $(PKGS_OPT) $(PKGS_GAMING_TWEAKS)


# -- Linux = FW --
PKGS_LINUX := linux-image-amd64
PKGS_LINUX += linux-headers-amd64
PKGS_LINUX += firmware-iwlwifi
PKGS_LINUX += firmware-realtek
PKGS_LINUX += firmware-misc-nonfree

# -- Utilities --
PKGS_UTILS := network-manager
PKGS_UTILS += wget curl git sudo
PKGS_UTILS += iptables tuned
PKGS_UTILS += i2c-tools python3-pip

# -- WWW Console (cockpit) --
PKGS_COCKPIT := cockpit cockpit-storaged

# -- DVD / Bluray / Media --
PKGS_BLURAY := vlc libaacs0 libbdplus0

# -- Hardware/Video graphics acceleration --
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

## -- X / Xorg --
PKGS_X11 := xserver-xorg xserver-xorg-core xinit

# -- KDE Plasma --
PKGS_PLASMA := kde-plasma-desktop
PKGS_DM_PLASMA := sddm

# -- GNOME --
PKGS_GNOME := gnome-core
PKGS_DM_GNOME := gdm3

## -- I3 (Minimal tiling) --
## (i3-gaps is "i3" in Debian; suckless dwm is source-based.)
## (For now, ships i3 + light DM for a usable minimal desktop.)
PKGS_I3 := i3 i3status dmenu xterm
PKGS_DM_I3 := lightdm

# --- Steam / Console Gaming ---
PKGS_STEAM := steam-installer
PKGS_STEAM += steam-devices
PKGS_STEAM += gamemode

# --- Gaming / performance tuning (config/gaming.mk) ---
# NOTE: gamemode itself is NOT repeated here -- it already ships via
# PKGS_STEAM above. This group is what the Ansible tasks in section 5 of
# playbook.yml configure (governor, PowerMizer, sysctl, I/O scheduler,
# MangoHud); it does not install the driver itself (that's PKGS_NVIDIA).
PKGS_GAMING_TWEAKS := linux-cpupower irqbalance mangohud
PKGS_GAMING_TWEAKS += vulkan-tools libvulkan1
PKGS_GAMING_TWEAKS += libvulkan1:i386

# --- Browsers ---
PKGS_BROWSER_FIREFOX := firefox
PKGS_BROWSER_CHROME  := chromium
PKGS_BROWSER_ELINKS  := elinks

# --- Office ---
PKGS_OFFICE_LIBRE := libreoffice
PKGS_OFFICE_LIBRE_GTK := libreoffice-gtk3
PKGS_OFFICE := $(PKGS_OFFICE_LIBRE) $(PKGS_OFFICE_LIBRE_GTK)
