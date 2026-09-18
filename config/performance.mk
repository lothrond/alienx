# --- performance tuning ---

# --- CPU ---
CPU_GOVERNOR_PERFORMANCE ?= true

# --- Kernel ---
SYSCTL_TUNING           := true
SYSCTL_VM_MAX_MAP_COUNT := 2147483642
SYSCTL_VM_SWAPPINESS    := 10

# --- I/O scheduler ---
IO_SCHEDULER_TUNING := true
IO_SCHEDULER_NVME   := none
IO_SCHEDULER_SSD    := mq-deadline
IO_SCHEDULER_HDD    := bfq

# --- NVIDIA (Maxwell) Graphics ---
NVIDIA_POWERMIZER_MAX_PERF := true
NVIDIA_ENABLE_MSI          := 1
NVIDIA_XORG_TUNING         := true
# 0 disables overclocking bits; set 12 or 28 only if you intend to
# overclock this specific card via nvidia-settings.
NVIDIA_COOLBITS            := 0
