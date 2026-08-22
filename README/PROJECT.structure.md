# mkdeb — Project Structure

Goal layout for `github.com/lothrond/mkdeb`. Confidence noted per section —
this project isn't fully visible to me at once, so some of this is
confirmed from your real files and some is inferred from naming
conventions and should be treated as a proposal, not a fact.

```
mkdeb/
├── Makefile                    # [confirmed] orchestrates: TARGET resolution,
│                                #   PKGS assembly, the inject: sed pipeline, ISO repack
├── config.mk                   # [confirmed exists, contents not reviewed]
├── README.md                   # [confirmed]
├── CHANGELOG.md                # [confirmed]
├── LICENSE                     # [confirmed exists]
├── .gitignore                  # [confirmed exists]
│
├── config/                     # [confirmed dir] Make-variable definitions,
│   │                           #   included per-profile via BUILD_CONFIG_*
│   ├── base.mk                 # [confirmed] shared defaults: ISO name, GRUB entry, BROWSER
│   ├── debian.mk                # [confirmed] Debian version/mirror, NON_FREE
│   ├── device.mk                 # [confirmed] DEVICE, PARTS
│   ├── network.mk                 # [confirmed] FIREWALL_ENABLED, WIFI_SSID/PASS
│   ├── packages.mk                # [confirmed, UPDATED this delivery] PKGS_* groups
│   │                               #   + PKGS_BASE/DESKTOP/CONSOLE composition
│   ├── system.mk                   # [confirmed] hostname, locale, timezone, Cockpit
│   ├── users.mk                     # [confirmed] admin/desktop/gamer account names
│   ├── desktop.mk                    # [confirmed] desktop-profile overrides
│   ├── console.mk                     # [confirmed] console-profile overrides
│   └── gaming.mk                       # [NEW, this delivery] gaming/perf tuning knobs
│                                       #   (console profile) -- see MAKEFILE_CHANGES.md
│                                       #   for the one Makefile edit that pulls it in
│
├── assets/                     # [confirmed dir] copied wholesale to $(BUILD_DIR)/assets
│   │                           #   by `inject:`, then sed-substituted in place
│   ├── preseed.cfg.template    # [confirmed] Debian installer preseed; __PKGS__ +
│   │                           #   every other __X__ token
│   ├── backgrounds/            # [inferred] wallpapers; currently empty per CHANGELOG
│   │                           #   ("removed until i disclaim ownership of logos")
│   │
│   └── ansible/                # [confirmed dir, from Makefile's
│       │                       #   `mkdir -p .../assets/ansible/group_vars`]
│       ├── playbook.yml        # [confirmed, UPDATED this delivery] single playbook,
│       │                       #   all post-install configuration
│       ├── group_vars/
│       │   └── all.yml         # [confirmed, UPDATED this delivery] single vars file,
│       │                       #   __X__ placeholders, auto-loaded by playbook.yml
│       └── files/               # [inferred from playbook.yml's `src: files/...`]
│           ├── grub.amd / grub.base / grub.intel / grub.nvidia    # [confirmed]
│           ├── iptables-firewall.sh / iptables-firewall.service   # [confirmed]
│           ├── steam-session.sh / steam-session.desktop           # [confirmed]
│           ├── steamos-update                                     # [confirmed]
│           ├── cpupower                    # [NEW, this delivery]
│           ├── gamemode.ini                # [NEW, this delivery]
│           ├── nvidia-perf.conf             # [NEW, this delivery] modprobe.d
│           ├── 20-nvidia-perf.conf           # [NEW, this delivery] xorg.conf.d
│           ├── 99-gaming-sysctl.conf          # [NEW, this delivery] sysctl.d
│           ├── 60-io-scheduler.rules           # [NEW, this delivery] udev rule
│           └── MangoHud.conf                    # [NEW, this delivery]
│
├── run/                        # [confirmed dir exists, contents NOT reviewed --
│                                #   github.com/lothrond/mkdeb/tree/main/run returned
│                                #   robots-disallowed when I tried to fetch it.
│                                #   README's Console section implies this is where
│                                #   the standalone-session/AlienFX-tooling pieces
│                                #   live, but that's a guess, not a fetch.]
│
└── work/                       # [inferred] build output/staging -- generated,
                                 #   presumably gitignored, not part of the repo proper
```

## What's actually new in this delivery

Only `config/gaming.mk` and the seven files under `assets/ansible/files/`
are net-new. `playbook.yml`, `group_vars/all.yml`, and `config/packages.mk`
are your existing files with gaming/perf tuning folded in — drop-in
replacements, not new files.

## Known gaps

- **`run/`** — never actually seen its contents. If it holds anything
  relevant to gaming/perf (e.g. a runtime AlienFX daemon), it isn't
  accounted for here.
- **`config.mk`** (top-level) — confirmed it exists, haven't reviewed what
  it sets. Possible it defines a default `TARGET`, which the Makefile
  seems to depend on for `BUILD_CONFIG_*` resolution.
- **Everything marked `[inferred]`** — reasoned from naming/references
  elsewhere, not fetched directly. Flag anything that's wrong and I'll
  correct this file.
