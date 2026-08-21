# --- Gaming / performance tuning (console profile) ---
#
# Sourced from ArchWiki: Gaming, Improving performance, GameMode,
# NVIDIA/Tips and tricks; and Debian Wiki: NvidiaGraphicsDrivers,
# NvidiaGraphicsDrivers/Configuration. Scoped to this hardware target:
# 6th-gen Skylake i5/i7, Nvidia Maxwell (GTX 745/960/970) on the
# nvidia-tesla-470 legacy branch (see CHANGELOG.md).
#
# Every value below is a placeholder wired through the Makefile's inject:
# sed block, feeding two places:
#   - assets/ansible/group_vars/all.yml  (booleans ansible tasks gate on)
#   - assets/ansible/files/*             (static configs, values baked in)
#
# Packages themselves are NOT listed here -- gamemode already ships via
# packages.mk's PKGS_STEAM; linux-cpupower/irqbalance/mangohud/vulkan
# libs are packages.mk's new PKGS_GAMING_TWEAKS group. Per this project's
# own preseed-installs/ansible-configures split (CHANGELOG.md "Design /
# Changes"), this file and playbook.yml section 5 only configure.

# --- CPU ---
GAMING_CPU_GOVERNOR_PERFORMANCE ?= true
GAMING_IRQBALANCE_ENABLED       ?= false
# ArchWiki (Improving performance): irqbalance can redistribute IRQs away
# from the core handling a game's interrupts and cause stutter. Off by
# default for a console/gaming target; the package installs either way
# (packages.mk), this only controls whether the service is enabled.

# --- GameMode ---
GAMING_GAMEMODE_ENABLED             ?= true
GAMING_GAMEMODE_IOPRIO              ?= 0
GAMING_GAMEMODE_RENICE              ?= 10
GAMING_GAMEMODE_SOFTREALTIME        ?= auto
GAMING_GAMEMODE_INHIBIT_SCREENSAVER ?= 1

# --- NVIDIA (Maxwell / nvidia-tesla-470) ---
GAMING_NVIDIA_POWERMIZER_MAX_PERF ?= true
GAMING_NVIDIA_ENABLE_MSI          ?= 1
GAMING_NVIDIA_XORG_TUNING         ?= true
GAMING_NVIDIA_COOLBITS            ?= 0
# 0 disables overclocking bits; set 12 or 28 only if you intend to
# overclock this specific card via nvidia-settings.

# --- Kernel / sysctl ---
GAMING_SYSCTL_TUNING           ?= true
GAMING_SYSCTL_VM_MAX_MAP_COUNT ?= 2147483642
GAMING_SYSCTL_VM_SWAPPINESS    ?= 10

# --- Storage / I/O scheduler ---
GAMING_IO_SCHEDULER_TUNING ?= true
GAMING_IO_SCHEDULER_NVME   ?= none
GAMING_IO_SCHEDULER_SSD    ?= mq-deadline
GAMING_IO_SCHEDULER_HDD    ?= bfq

# --- Overlay ---
GAMING_MANGOHUD_ENABLED ?= true
# vulkan-tools/libvulkan1 (+:i386 for Proton) are NOT flagged here --
# they're small, just the loader + diagnostics, needed by DXVK/VKD3D
# regardless of which ICD provides the driver, and always ship in
# PKGS_GAMING_TWEAKS (packages.mk) on the console profile. mesa-vulkan-
# drivers itself was left out -- NVIDIA's own ICD (PKGS_NVIDIA) is what
# actually drives Vulkan on this hardware.
