# Design / Changes (current)
---

### I Fed/Subjected this to Claude (and Grok).
#### (I had to clean up after they left.)

---

## Main

* `make` is a single incantation.
	* Build targets are defined as profiles in `config.mk`

* **Session type** is the main graphics-related choice: `x11` or `wayland`.
* **Hardware acceleration** and **Blu-ray** packages are always included on
  desktop and console profiles.
* **Packages** are defined once in `config/packages.mk` as named groups;
  profiles and feature flags only *select* groups.
* **Preseed** installs packages; **Ansible** configures the system and handles
  non-apt tools (ProtonUp-Qt, Decky Loader).

## Added

* **gaming.mk** console gaming performance tuning, for now.
	* Got desktop peformace tuning?

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


## Packages

* **`PKGS_BASE`**: kernel, utils, cockpit
* **`PKGS_DESKTOP`**: base + Nvidia + accel + Blu-ray + X11 + Plasma + SDDM
* **`PKGS_CONSOLE`**: desktop + 32-bit Nvidia libs + Steam

## Building/Making

* `make`

## Project structure

* Profile target is configured in `config.mk`.
* Configuration directory is `./config`.
* Work directory is `./work`.
* Ansible is `./assets`
* Override anything.

## Nvidia driver updates (important)

Debian’s **nvidia-tesla-470** packages are the supported proprietary package path.

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
  still run as gamer user.
* Installer:

  ```text
  https://github.com/SteamDeckHomebrew/decky-installer/releases/latest/download/install_release.sh
  ```

* Expect to finish setup **inside a real Steam Big Picture session** with
  network.  Plugins/themes live under `~/homebrew/plugins`.
* If Decky does not appear, re-run the installer from a terminal as gamer, or
  skip it and use desktop-mode tools instead.

### Other Deck ideas

* **EmuDeck**
* **Gamescope**
* **MangoHud / goverlay**

### Why?

* Just ignore any `.letitgo` things. 
    * (Gotta problem?)
        * 👍

### Still broken?

* Probably
    * I get tired/crazy

### Backgrounds?

* Removed custom backgrounds until i disclaim ownership of steam/valve/alienware.
    * I do not own these logos

### Future?

	* ChromeOS devices.
	* Maybe define `server` profile ...
		* Also, `server-gui` profile ...
	* And more Ansible
