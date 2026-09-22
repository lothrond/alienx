# --- package configuration settings ---

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

## Wayland
PKGS_WAYLAND := # Got wayland?

## X11 (Xorg)
PKGS_X := xserver-xorg xserver-xorg-core xinit

# --- Graphics ---

## Hardware/Video Graphics acceleration
PKGS_ACCEL_COMMON := vainfo mesa-va-drivers mesa-vdpau-drivers

## Nvidia – Maxwell (GTX 745/960/970)
##
## - Tesla 470 is the Maxwell/Kepler branch.
## - On Trixie, if nvidia-tesla-470-* is missing from the mirror,
##   switch these to:
##   * nvidia-driver
##   * nvidia-driver-libs:i386
##
## (550 still lists Maxwell support).
PKGS_GFX_NVIDIA := nvidia-tesla-470-driver
PKGS_GFX_NVIDIA += xserver-xorg-video-nvidia-tesla-470
PKGS_GFX_NVIDIA += nvidia-tesla-470-vulkan-icd
PKGS_GFX_NVIDIA += nvidia-tesla-470-vdpau-driver
PKGS_GFX_NVIDIA32 := nvidia-tesla-470-driver-libs:i386
PKGS_GFX_NVIDIA32 += libnvidia-gl-470:i386
PKGS_GFX_NVIDIA_ACCEL := $(PKGS_ACCEL_COMMON)

## AMD – generic modern stack (amdgpu + Mesa)
## (Edit when i find exact GPU (GCN / RDNA generation).)
PKGS_GFX_AMD := firmware-amd-graphics
PKGS_GFX_AMD += xserver-xorg-video-amdgpu
PKGS_GFX_AMD += mesa-vulkan-drivers
PKGS_GFX_AMD += libgl1-mesa-dri
PKGS_GFX_AMD32 := mesa-vulkan-drivers:i386
PKGS_GFX_AMD32 += libgl1-mesa-dri:i386
PKGS_GFX_AMD_ACCEL := $(PKGS_ACCEL_COMMON)

## Intel – Skylake-class iGPU (HD 530 etc.)
## (And similar GEN9+)
PKGS_GFX_INTEL := firmware-intel-graphics
PKGS_GFX_INTEL += xserver-xorg-video-intel
PKGS_GFX_INTEL += mesa-vulkan-drivers
PKGS_GFX_INTEL += libgl1-mesa-dri
PKGS_GFX_INTEL += intel-media-va-driver-non-free
PKGS_GFX_INTEL32 := mesa-vulkan-drivers:i386
PKGS_GFX_INTEL32 += libgl1-mesa-dri:i386
PKGS_GFX_INTEL_ACCEL := $(PKGS_ACCEL_COMMON)
PKGS_GFX_INTEL_ACCEL += intel-media-va-driver-non-free

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
PKGS_GNOME := $(PKGS_DESKTOP_GTERM)

## KDE Plasma Desktop (WIP)
PKGS_DE_PLASMA := kde-plasma-desktop
PKGS_PLASMA := $(PKGS_DE_PLASMA) $(PKGS_DM_SDDM)
PKGS_PLASMA := $(PKGS_DESKTOP_KTERM)

## I3 (Minimal tiling) Desktop (WIP)
##  * (i3-gaps is "i3" in Debian; suckless dwm is source-based.)
##  * (For now, ships i3 + light DM for a usable minimal desktop.)
PKGS_DE_I3 := i3 i3status dmenu xterm
PKGS_I3 := $(PKGS_DE_I3) $(PKGS_DM_LIGHT)
PKGS_I3 := $(PKGS_DESKTOP_XTERM)

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

# --- Utility Applications ---

## GNOME Terminal
PKGS_GTERM := gnome-terminal

## Konsole Terminal
PKGS_KTERM := konsole

## XTerm Terminal
PKGS_XTERM := xterm

# --- WWW Browser Applications ---

## Firefox
PKGS_BROWSER_FIREFOX := firefox

## Chrome
PKGS_BROWSER_CHROME := chromium

## Elinks (CLI)
PKGS_BROWSER_ELINKS := elinks

# --- Console ---

## Steam
PKGS_STEAM_CONSOLE := steam-installer
PKGS_STEAM_CONSOLE += steam-devices
PKGS_STEAM_CONSOLE += gamemode

## Vulkan
PKGS_GFX_VULKAN := vulkan-tools libvulkan1
PKGS_GFX_VULKAN32 := libvulkan1:i386

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

# --- (Dummy package) ---
PKGS_NONE := $(PKGS_BASE)
