#### ⚠️ WIP
# Alienware X51 R3 Debian Build System

#### --> This repository provides: 
- a `Makefile` system
- a `Debian 13` `(Trixie)` `preseed`
- an `ansible` build system

#### --> This repository generates custom, static ISO images.

#### --> These images are tailored specifically for the `Alienware X51 R3` hardware architecture.

## Hardware Targeting
#### --> This build is trying to cover the complete range of component options for the
`Alienware X51 R3` motherboard (`Intel Z170 chipset`):

### Processors (CPU):
- AMD is WIP
- 6th-Generation `Intel Skylake` CPUs
- including the `Intel Core i3`
- `i5-6400`
- `i5-6600K`
- And `i7-6700K`

### Graphics (GPU):
- AMD is WIP
- Nvidia Maxwell architecture cards
    * `GeForce GTX 745`
    * `GTX 960`
    * `GTX 970`
    *  As well as integrated `Intel HD Graphics`

- (Proprietary nvidia setups enforce early KMS and blacklist the open-source driver)

### Networking:
- Intel Wireless Wi-Fi
    * `Intel 3165 802.11ac` chipset 
        * `firmware-iwlwifi`
        * `firmware-realtek`
- Ethernet is WIP
- Other WIFI is WIP

### Audio:
- `Realtek ALC892 High Definition Audio` codec

### Storage:
- M.2 NVMe SSDs
- 3.5-inch SATA drives

### Optical Drive:
- Internal slot-loading DVD/Blu-ray combo drives

### Lighting:
- AlienFX case lighting system
	* Pre-equipped with `i2c-tools` and `python3-pip`
		* For (e.g., `alienfx-tools`).

### Graphics Amplification:
- Additional graphics from the proprietary graphics amp are WIP

## Profiles

#### --> Make build targets are defined as profiles.

#### --> There are a few build targets that define profiles:

- **`base`**: Defines a minimal base profile
- **`console`**: Defines a console gaming profile
- **`desktop`**: Defines a desktop profile

### Profile Settings

#### --> The current static way to configure a profile is in **`config.mk`**.

#### --> The **`PROFILE`** variable sets the profile.

### Profile Configuration

#### --> The `config` directory contains all profile configuration settings.

#### --> The configuration layout for the `base` profile:

- `debian.mk`
- `device.mk`
- `base.mk`
- `network.mk`
- `users.mk`
- `passwords.mk`

#### --> The configuration layout for the `console` profile:

- `console.mk`
- `gaming.mk`
- `users.mk`
- `passwords.mk`

#### --> The configuration layout for the `desktop` profile:

- `desktop.mk`
- `users.mk`
- `passwords.mk`

## Base Profile

#### --> The `base` profile is configurable in `config.mk`.

#### --> `base.mk`
- Contains the main profile configurations

### Base Environment

| Environment  | Info              | Value              |
|------------- |-------------------|--------------------|
| `LOCAL_HOST` | Set system hostname | `alienware-x51-r3` |
| `LOCAL_TZ`   | Set system timezone | UTC |
| `LOCAL_LANG` | Set system language | English US |
| `LOCAL_KEYS` | Set keyboad keymap | `en_US.UTF-8` |
| (⚠️ WIP) `BROWSER` | WWW browser | `elinks` \| `none` |
| (⚠️ WIP) `COCKPIT_ENABLED` | Optional WWW console | `true` \| `false` |
| (⚠️ WIP) `COCKPIT_PORT` | Change/Keep www console port | `9090` |
| `OUTPUT_ISO` | Name the ISO | `debian-alienx-base-autoinst.iso` |
| `GRUB_ENRTY` | Name the bootloader entry | `ALIENWARE X51 R3 - BASE - AUTOMATED RECOVERY - (PRESEED) - (PLAYBOOK)` |

### Base Profile Information

- **`Based From Debian`:**
    * Uses a `Debian` `x86_64` image

- **Includes Additional Utilites:**
    * Packages include: `curl`, `git`, `sudo`, and more

- **(⚠️ WIP) WWW Console Support:**
    * Disabled by default
    * Uses `cockpit`
    * Port is configurable

## Desktop Profile

#### --> The `desktop` profile is configured in `config.mk`.

#### --> `config/desktop.mk`
- Contains the main profile configurations

| Environment     | Info     |  Value             |
|-----------------|----------|--------------------|
| `DRIVER_STACK`  | Select graphics card | `amd`  \| `intel` \| `nvidia` | 
| `SESSION_TYPE`  | Select session | `x11`  \| `wayland` |
| (⚠️ WIP) `BROWSER` | WWW browser | `chrome` \| `firefox` |
| ⚠️ `BLURAY_SUPPORT` | Enable bluray-dvd disk support | `false` \| `true` |
| (⚠️ WIP) `OFFICE` | Enable an office suite | `libre` \| `none` |
| (⚠️ WIP) `DESKTOP` | Selects a desktop environment | `gnome` \| `plasma` \| `i3` |
| `OUTPUT_ISO` | Name the ISO | `debian-alienx-base-autoinst.iso` |
| `GRUB_ENRTY` | Name the bootloader entry | `ALIENWARE X51 R3 - DESKTOP - AUTOMATED RECOVERY - (PRESEED) - (PLAYBOOK)` |

### Desktop Profile Information

- **Session Defaults:**
    * `plasma` desktop
    * `wayland` session

- **(⚠️ WIP) Graphics:**
    * Defaults to using nonfree `nvidia` graphics

- **(⚠️ WIP) Bluray/DVD Support:**
    * Disabled by default
    * **⚠️ `BLURAY_SUPPORT`:** Requires one to supply thier own `KEYDB.cfg` file

- **(⚠️ WIP) Browser Support:**
    * Defaults to using the `firefox` web browser
    * The `chrome` web browser is 

- **(⚠️ WIP) Office Support:**
    * Enabled by default
    * **`libre`:** Uses `libreoffice`

- **(⚠️ WIP) WWW Console Support:**
    * Disabled by default
    * Uses `cockpit`
    * Port is configurable

## Console Profile

#### --> The `console` profile is configured in `config.mk`.

#### --> `config/console.mk`
- Contains the main profile configurations

### Console Profile Environent

| Environment     | Info     |  Value             |
|-----------------|----------|--------------------|
| `DRIVER_STACK`  | Select graphics card | `amd`  \| `intel` \| `nvidia` | 
| `SESSION_TYPE`  | Select session | `x11`  \| `wayland` |
| (⚠️ WIP) `PROTON_GE` | Enable Proton GE | `true` \| `false` |
| (⚠️ WIP) `DECKY` | Enable decky loader | `true` \| `false` |
| (⚠️ WIP) `COCKPIT_ENABLED` | Optional www console | `true` \| `false` |
| (⚠️ WIP) `COCKPIT_PORT` | Change/Keep www console port | `9090` |
| `OUTPUT_ISO` | Name the ISO | `debian-alienx-console-autoinst.iso` |
| `GRUB_ENRTY` | Name the bootloader entry | `ALIENWARE X51 R3 - DESKTOP - AUTOMATED RECOVERY - (PRESEED) - (PLAYBOOK)` |

### Console Profile Information

- **(⚠️ WIP) Console Graphics:**
    * Defaults to using proprierary nvidia

- **(⚠️ WIP) Standalone Session:**
    * A display manager launches a custom desktop session
        * Suppresses screen blanking 
        * Injects Feral GameMode (`gamemoderun`)
        * Passes arguments to `steam`

- **(⚠️ WIP) Native Steam:**
    * I chose `Debian` specifically for the `i386` support
    * This should allow better `steam-devices` support for controllers too

- **(⚠️ WIP) SteamOS Update Button:**
    * Steam is invoked with `-steamos`
        * Big Picture Mode enables the "Update System" interface button
    * This links directly to `/usr/bin/steamos-update`
        * This updates any `Debian` packages in the background
            * `apt`/`dpkg`
            * `flatpak`
            * `snap` (for some reason) (⚠️ WIP)

- **(⚠️ WIP) Decky loader**:
    * Support for installing decky loader
    * Support for installing decky loader themes

- **(⚠️ WIP) Proton (Glorious Eggroll)**:
    * Supports/installs `proton-ge-updater`

- **(⚠️ WIP) Bluray/DVD Support:**
    * Disabled by default
    * **⚠️ `BLURAY_SUPPORT`:** Requires one to supply thier own `KEYDB.cfg` file

- **(⚠️ WIP) WWW Console Support:**
    * Enabled by default
    * Uses `cockpit`
    * Port is configurable

### Console Profile Performance

#### --> `config/gaming.mk`
- Contains configurations for console gaming performance

## Usage Instructions

#### --> Compile a minimal base system, a system for couch console play, or a minimal desktop system ISO:

    make

- **`make depends`**: Install needed build dependencies

- **`make clean`**: Purges the work directory
	* **`make cleanbuilds`**: For a clean build

- **See `make help` for more information**

## Installation

#### --> All installation configuration options are stored in `config/install.mk`.

- **`make install`**: Install to a configured USB drive 
- **(⚠️ WIP) `make install-dvd`**: Install to a configured DVD

## Booting The Target Profile

- Insert the newly flashed USB/DVD into the target hardware
- Power on the machine
- Boot USB/DVD
    * Enter the BIOS/UEFI boot menu
    * Select the USB/DVD drive as the primary boot device
- Step back
    * **⚠️**

---

## 🌐 Remote Management (Cockpit)

Once the automated installation is complete, you can manage the system remotely.

Open a web browser on another device on the local network:

    http://<target-host-ip>:<`COCKPIT_PORT`>

Log in using the admin account credentials to handle updates, storage, or access a root shell.
(`COCKPIT_PORT` defaults to `9090`)

#### ⚠️ WARNING: This is a zero-touch, fully unattended installer. The moment you boot the machine from this USB drive, the configuration will automatically wipe the primary disk and install the OS without asking for any confirmation. Do not boot this on a machine containing data you wish to keep.

##### (Also, for `steamdeck` devices, shouldn't all documents be called deckuments?)

### License

GPL-3.0 (see LICENSE)
