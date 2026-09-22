# --- performance configuration settings ---

# --- Define CPU governor ---
CPU_GOVERNOR_PERFORMANCE ?= true

# --- Define Linux kernel performance ---
SYSCTL_TUNING           := true
SYSCTL_VM_MAX_MAP_COUNT := 2147483642
SYSCTL_VM_SWAPPINESS    := 10

# --- Define I/O scheduler performance ---
IO_SCHEDULER_TUNING := true
IO_SCHEDULER_NVME   := none
IO_SCHEDULER_SSD    := mq-deadline
IO_SCHEDULER_HDD    := bfq

# --- Define NVIDIA (Maxwell) graphics performance ---
NVIDIA_POWERMIZER_MAX_PERF := true
NVIDIA_ENABLE_MSI          := 1
NVIDIA_XORG_TUNING         := true
# 0 disables overclocking bits; set 12 or 28 only if you intend to
# overclock this specific card via nvidia-settings.
NVIDIA_COOLBITS            := 0
