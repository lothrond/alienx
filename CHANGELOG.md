

## Design / Changes (current)

* **Session type** is the main graphics-related choice: `x11` or `wayland`.
* **Hardware acceleration** and **Blu-ray** packages are always included on
  desktop and console profiles.
* **Packages** are defined once in `config/packages.mk` as named groups;
  profiles and feature flags only *select* groups.
* **Preseed** installs packages; **Ansible** configures the system and handles
  non-apt tools (ProtonUp-Qt, Decky Loader).

## Profile targets

| Target    | Purpose                         | Users         |
|-----------|---------------------------------|---------------|
| `base`    | Minimal server / recovery       | admin only    |
| `desktop` | Plasma desktop + Nvidia         | admin only    |
| `console` | Steam Big Picture appliance     | admin + gamer |

Root is always locked.  Use `sudo` from **admin**.

## Feature flags

| Variable        | Values                         | Where      |
|-----------------|--------------------------------|------------|
| `SESSION_TYPE`  | `x11` \| `wayland`             | desktop/console |
| `BROWSER`       | `none` \| `firefox` \| `chrome` \| `elinks` | all |
| `OFFICE`        | `true` \| `false` (LibreOffice)| desktop    |
| `PROTON_GE`     | `true` \| `false` (ProtonUp-Qt Flatpak) | console |
| `DECKY`         | `true` \| `false` (Decky Loader)        | console |


## packages.mk layout

All package **names** live in atomic groups (`PKGS_LINUX`, `PKGS_NVIDIA`, …).
Composed sets:

* `PKGS_BASE` – kernel, utils, cockpit  
* `PKGS_DESKTOP` – base + Nvidia + accel + Blu-ray + X11 + Plasma + SDDM  
* `PKGS_CONSOLE` – desktop + 32-bit Nvidia libs + Steam  

The Makefile’s `assemble-pkgs` macro appends browser / office groups from flags.
That final list is injected into preseed as `__PKGS__`.  Ansible does **not**
re-list those packages.

## Passwords

Prompted at build time (admin always; gamer on console).  Hashed with SHA-512
crypt inside the Makefile; only hashes go into the ISO.

## Building

`make`

Work directory is `./work`.  Override anything via `config.mk` or the command line.

## Nvidia driver updates (important)

Your GPUs are **Maxwell**.  Debian’s **nvidia-tesla-470** packages are the
supported proprietary path.

1. **Stay on the 470 branch.**  
   Normal updates are fine:

   ```bash
   sudo apt update
   sudo apt upgrade
   ```

   DKMS will rebuild the 470 kernel module for new kernels when
   `linux-headers` are installed.

2. **Do not install `nvidia-driver` (current branch)** on this machine.  
   Newer branches drop older GPUs or behave differently; they can replace
   or conflict with 470 packages.

3. **If a major Debian upgrade tries to pull a newer Nvidia metapackage**,  
   hold the 470 packages:

   ```bash
   sudo apt-mark hold nvidia-tesla-470-driver nvidia-tesla-470-kernel-dkms
   ```

4. **Security / long-term:** 470 is a legacy branch.  When Debian eventually
   removes it, options are: stay on an older release, use Nouveau (not the
   goal of this image), or a carefully pinned external 470 build.  Plan
   around that when the time comes.

5. **Console steamos-update helper** only runs `apt upgrade` (+ flatpak).
   It will not jump Nvidia branches by itself if you hold the packages.

## Steam Deck–style customization on Debian

This image is **Debian + Steam**, not SteamOS.  Some Deck tools work; some are
best-effort.

### Proton-GE (`PROTON_GE=true`)

* Installs **Flatpak** + **ProtonUp-Qt** (`net.davidotek.pupgui2` on Flathub).
* After first boot (as gamer or admin):

  ```bash
  flatpak run net.davidotek.pupgui2
  ```

  Install the latest **GE-Proton**.  In Steam → game Properties → Compatibility,
  force that GE version.

* Alternative: AppImage from [ProtonUp-Qt releases](https://github.com/DavidoTek/ProtonUp-Qt/releases).

### Decky Loader (`DECKY=true`)

* Official project targets **SteamOS / Steam Deck UI**.  On plain Debian +
  native Steam Big Picture it is **unsupported** but the installer script is
  still run best-effort as the gamer user.
* Installer:

  ```text
  https://github.com/SteamDeckHomebrew/decky-installer/releases/latest/download/install_release.sh
  ```

* Expect to finish setup **inside a real Steam Big Picture session** with
  network.  Plugins/themes live under `~/homebrew/plugins`.
* If Decky does not appear, re-run the installer from a terminal as gamer, or
  skip it and use desktop-mode tools instead.

### Themes & plugins

* Prefer Decky’s built-in plugin store once Loader is running.
* CSS/theme plugins are Decky plugins, not separate apt packages—no need to
  put them in `packages.mk`.

### Other Deck-adjacent ideas (not automated yet)

* **EmuDeck** – large installer; better run manually after first boot.
* **Gamescope** – optional nested compositor; useful with X11/Steam.
* **MangoHud / goverlay** – performance overlay; can be added as a
  `PKGS_GAMING` group later if you want it always on.

### Why?

* Just ignore any `.letitgo` things. 
    * (Gotta problem?)
        * 👍

### Why are you writing this?