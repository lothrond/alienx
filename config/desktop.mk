# --- desktop configuration settings ---

# --- Name the ISO ---
OUTPUT_ISO := ./alienware-debian-desktop-wayland-nouveau.iso

# -- Name the bootloader menu entry ---
GRUB_ENTRY := ALIENWARE X51 R3 - DESKTOP - AUTOMATED RECOVERY (PRESEED)

# --- Define graphics settings ---
DRIVER_STACK := nouveau
SESSION_TYPE := wayland

# --- Define application support ---
BLURAY_SUPPORT := false
NATIVE_STEAM := false
BROWSER := firefox

# --- Define user account settings ---
ROOT_PASSWORD := rootpassword123
USER_PASSWORD := userpassword123

# --- Define network settings ---
WIFI_SSID := MyHomeNetwork
WIFI_PASS := SuperSecretPassword
