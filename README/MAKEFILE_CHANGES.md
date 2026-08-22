# Makefile changes needed

Everything else in this delivery (`playbook.yml`, `group_vars/all.yml`,
`config/packages.mk`, `config/gaming.mk`, and the files under
`assets/ansible/files/`) is a complete drop-in replacement or new file —
copy it in and overwrite. The Makefile is the one file I'm not handing you
a full replacement for: I only have it via a fetched GitHub blob view, and
Makefiles are whitespace-sensitive (recipe lines need real tabs) in a way
that rendered/extracted web content can silently corrupt. These two edits
are verified against your real file's actual content, not guessed:

## 1. Pull gaming.mk into the console profile

Find:

```makefile
## Console profile
BUILD_CONFIG_CONSOLE := $(BUILD_CONFIG_BASE)
BUILD_CONFIG_CONSOLE += $(CONFIG)/console.mk
```

Add:

```makefile
BUILD_CONFIG_CONSOLE += $(CONFIG)/gaming.mk
```

## 2. Extend the `inject:` sed chain

Your `inject:` target already runs one long `sed -i -e "s|__X__|$(X)|g" ...`
chain across every `.template/.yml/.yaml/.sh/.desktop/.conf/.service` file
under `assets/`. Add these lines anywhere in that chain, before the
closing `{} +;`:

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

That's it — no new line needed for the gamer username in `all.yml`; it
reuses your existing `__USER_GAME__` token, already in that chain.

## What's superseded from earlier in this chat

Ignore/discard the standalone `roles/gaming_performance/` role and the
separate `assets/ansible/playbook.yml` + `group_vars/all.yml` I built
before checking your real files. This delivery replaces both — there's
only ever one playbook.yml and one group_vars/all.yml, matching what your
project already had.
