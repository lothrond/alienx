# Integration notes for mkdeb

Three edits to your actual repo. I have the real Makefile and config.mk in
front of me for #1 and #2, so these are exact. #3 I'm inferring from
CHANGELOG.md's description of packages.mk since I haven't seen that file's
real content — check the placement before committing.

## 1. Makefile — pull gaming.mk into the console profile

Find:

```makefile
## Console profile
BUILD_CONFIG_CONSOLE := $(BUILD_CONFIG_BASE)
BUILD_CONFIG_CONSOLE += $(CONFIG)/console.mk
```

Add one line under it:

```makefile
BUILD_CONFIG_CONSOLE += $(CONFIG)/gaming.mk
```

## 2. Makefile — extend the `inject:` sed chain

Your `inject:` target already has one big `sed -i -e "s|__X__|$(X)|g" ...`
chain that runs across every `.template/.yml/.yaml/.sh/.desktop/.conf/.service`
file under `assets/`. Add these lines anywhere in that chain (before the
closing `{} +;`):

```makefile
        -e "s|__GAMING_CPU_GOVERNOR_PERFORMANCE__|$(GAMING_CPU_GOVERNOR_PERFORMANCE)|g" \
        -e "s|__GAMING_IRQBALANCE_ENABLED__|$(GAMING_IRQBALANCE_ENABLED)|g" \
        -e "s|__GAMING_GAMEMODE_ENABLED__|$(GAMING_GAMEMODE_ENABLED)|g" \
        -e "s|__GAMING_GAMEMODE_IOPRIO__|$(GAMING_GAMEMODE_IOPRIO)|g" \
        -e "s|__GAMING_GAMEMODE_RENICE__|$(GAMING_GAMEMODE_RENICE)|g" \
        -e "s|__GAMING_GAMEMODE_SOFTREALTIME__|$(GAMING_GAMEMODE_SOFTREALTIME)|g" \
        -e "s|__GAMING_GAMEMODE_INHIBIT_SCREENSAVER__|$(GAMING_GAMEMODE_INHIBIT_SCREENSAVER)|g" \
        -e "s|__GAMING_NVIDIA_POWERMIZER_MAX_PERF__|$(GAMING_NVIDIA_POWERMIZER_MAX_PERF)|g" \
        -e "s|__GAMING_NVIDIA_ENABLE_MSI__|$(GAMING_NVIDIA_ENABLE_MSI)|g" \
        -e "s|__GAMING_NVIDIA_XORG_TUNING__|$(GAMING_NVIDIA_XORG_TUNING)|g" \
        -e "s|__GAMING_NVIDIA_COOLBITS__|$(GAMING_NVIDIA_COOLBITS)|g" \
        -e "s|__GAMING_SYSCTL_TUNING__|$(GAMING_SYSCTL_TUNING)|g" \
        -e "s|__GAMING_SYSCTL_VM_MAX_MAP_COUNT__|$(GAMING_SYSCTL_VM_MAX_MAP_COUNT)|g" \
        -e "s|__GAMING_SYSCTL_VM_SWAPPINESS__|$(GAMING_SYSCTL_VM_SWAPPINESS)|g" \
        -e "s|__GAMING_IO_SCHEDULER_TUNING__|$(GAMING_IO_SCHEDULER_TUNING)|g" \
        -e "s|__GAMING_IO_SCHEDULER_NVME__|$(GAMING_IO_SCHEDULER_NVME)|g" \
        -e "s|__GAMING_IO_SCHEDULER_SSD__|$(GAMING_IO_SCHEDULER_SSD)|g" \
        -e "s|__GAMING_IO_SCHEDULER_HDD__|$(GAMING_IO_SCHEDULER_HDD)|g" \
        -e "s|__GAMING_MANGOHUD_ENABLED__|$(GAMING_MANGOHUD_ENABLED)|g" \
```

Note what's *not* here: `gamer_username` in `group_vars/all.yml` uses
`__USER_GAME__`, which is already substituted by your existing
`-e "s|__USER_GAME__|$(USER_GAME)|g"` line. No new line needed for that one.

## 3. packages.mk — new atomic group (placement is a guess)

CHANGELOG.md describes atomic groups like `PKGS_LINUX`/`PKGS_NVIDIA`
composing into `PKGS_CONSOLE`, but I haven't seen packages.mk itself, so I
don't know its exact variable-composition syntax. Add something like:

```makefile
# --- Gaming/performance tuning packages (config/gaming.mk) ---
PKGS_GAMING_TWEAKS := gamemode linux-cpupower irqbalance mangohud
PKGS_GAMING_TWEAKS += mesa-vulkan-drivers vulkan-tools libvulkan1
PKGS_GAMING_TWEAKS += mesa-vulkan-drivers:i386 libvulkan1:i386
```

...then fold it into wherever `PKGS_CONSOLE` is actually composed, e.g.:

```makefile
PKGS_CONSOLE += $(PKGS_GAMING_TWEAKS)
```

Unconditional, not behind its own flag — same treatment as Steam itself in
`PKGS_CONSOLE`, since this is what makes the console profile a *gaming*
console. The individual `GAMING_*` flags in `gaming.mk` control which
tunings get **configured** by Ansible, not whether the packages get
**installed**.

Paste your real packages.mk if you want this placed exactly instead of
appended blind.
