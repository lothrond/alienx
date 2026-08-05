# --- nvidia (maxwell) graphics configuration ---

# --- Define nvidia (maxwell) graphics driver ---
NVIDIA_DRIVER :=

# --- Define nvidia (maxwell) graphics driver packages ---
PKGS_GFX_NVIDIA := $(PKGS_GFX_NVIDIA_MAXWELL)
PKGS_GFX_NVIDIA_MAXWELL := 

# --- Define nvidia (maxwell) graphics 32bit library support ---
PKGS_GFX_NVIDIA_32 := $(PKGS_GFX_NVIDIA_MAXWELL_32)
PKGS_GFX_NVIDIA_MAXWELL_32 := nvidia-tesla-470-driver-libs:i386
