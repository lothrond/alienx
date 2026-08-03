# --- console configuration settings ---

# --- Name the ISO ---
OUTPUT_ISO := ./alienware-debian-console-x11-nvidia.iso

# -- Name the bootloader menu entry ---
GRUB_ENTRY := ALIENWARE X51 R3 - CONSOLE - AUTOMATED RECOVERY (PRESEED)

# --- Define graphics settings ---
DRIVER_STACK := nvidia
SESSION_TYPE := x11

# --- Define application support ---
BLURAY_SUPPORT := true
NATIVE_STEAM := true
BROWSER := chrome

# --- Define user account settings ---
ROOT_PASSWORD := rootpassword123
USER_PASSWORD := userpassword123

# --- Define network settings ---
WIFI_SSID := MyHomeNetwork
WIFI_PASS := SuperSecretPassword
