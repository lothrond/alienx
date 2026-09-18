# --- console gaming ---

# --- CPU ---
# ArchWiki (Improving performance): irqbalance can redistribute IRQs away
# from the core handling a game's interrupts and cause stutter. Off by
# default for a console/gaming target; the package installs either way
# (packages.mk), this only controls whether the service is enabled.
CPU_IRQBALANCE_ENABLED ?= false

# --- GameMode ---
GAMEMODE_ENABLED             ?= true
GAMEMODE_IOPRIO              := 0
GAMEMODE_RENICE              := 10
GAMEMODE_SOFTREALTIME        ?= auto
GAMEMODE_INHIBIT_SCREENSAVER := 1

# --- Overlay ---
MANGOHUD_ENABLED := true
