# Debian Build System: Alienware X51 R3

This repository provides an automated `Makefile`, Debian 13 (Trixie) preseed,
and ansible build system to generate custom, static ISO images.
Tailored specifically for the Alienware X51 R3 hardware architecture.

#### ⚠️ WIP

## Hardware Targeting

This build is Trying to cover the complete range of component options for the Alienware X51 R3 motherboard
(Intel Z170 chipset):

* **Processors (CPU):** 6th-Generation Skylake CPUs
    * including the Intel Core i3
    * i5-6400
    * i5-6600K
    * And i7-6700K

* **Graphics (GPU):** Nvidia Maxwell architecture cards
    * GeForce GTX 745
    * GTX 960
    * GTX 970
    * As well as integrated Intel HD Graphics

* (Proprietary Nvidia setups enforce `nvidia-drm.modeset=1` and blacklist the open-source driver.)

* **Networking:** Intel Wireless Wi-Fi
    * Intel 3165 802.11ac chipset 
    * Supported natively via pre-baked `firmware-iwlwifi` and `firmware-realtek`.

* **Audio:** Realtek ALC892 High Definition Audio codec.

* **Storage:** Support for M.2 NVMe SSDs and standard 3.5-inch SATA hard drives.

* **Optical Drive:** Internal slot-loading DVD/Blu-ray combo drives.

* **Lighting:** AlienFX case lighting system
	* Pre-equipped with `i2c-tools` and `python3-pip`
		* For (e.g., `alienfx-tools`).

## Profiles

* Make build targets are defined as profiles
* There are a few build targets that define profiles:
    * **`base`**: Defines a minimal base profile
	* **`console`**: Defines a console gaming profile
    * **`desktop`**: Defines a desktop profile

### Profile Settings

* **`config.mk`**: The current static way to define a profile.
* The **`TARGET`** variable will set the profile.

### Profile Configuration

The `config` directory contains all profile configuration settings.

* The configuration layout for the `base` profile:
    * `debian.mk`
    * `device.mk`
    * `base.mk`
    * `network.mk`
    * `users.mk`
    * `passwords.mk`

* The configuration layout for the `console` profile:
    * `console.mk`
    * `gaming.mk`
    * `users.mk`
    * `passwords.mk`

* The configuration layout for the `desktop` profile:
    * `desktop.mk`
    * `users.mk`
    * `passwords.mk`

##  (⚠️ WIP) Base Profile

* The `base` profile is configurable in `config.mk`

### Base Profile Information

* A minimal Debian x86_64 base system
* Includes optional additional utilites

## (⚠️ WIP) Desktop Profile

* The `desktop` profile is configurable in `config.mk`
* **`config/desktop,mk`**: Contains the main profiles configuratiions.
* **`DESKTOP`**: Selects a desktop environment.
    * **`DESKTOP`** has a few options:
        * `gnome`
        * `plasma`
        * `i3`

#### Desktop Profile Information

* **Session Defaults:**
    * plasma desktop
    * wayland session

* **Graphics:**
    * Defaults to using propriatary nvidia graphics
        * With nouveau blacklisted

* **Bluray/DVD Support:**
    * Supply your own `KEYDB.cfg`

* **Office Support:**
    * Uses libreoffice

## (⚠️ WIP) Console Profile

* The `console` profile is configurable in `config.mk`
* **`config/console.mk`**: Contains the main profile configurations

### Console Profile Information

* **Standalone Session:**
    * A display manager launches a custom desktop session
        * This script suppresses screen blanking
        * injects Feral GameMode (`gamemoderun`)
        * Passes arguments to Steam

* **SteamOS Update Button:**
    * Steam is invoked with `-steamos`
        * Big Picture Mode enables the "Update System" interface button
    * This links directly to `/usr/bin/steamos-update`
        * This updates any debian packages in the background
            * apt
            * flatpak
            * snap (for some reason) (⚠️ WIP)

* **(⚠️ WIP) Decky loader**:
    * Support for installing decky loader
    * Support for installing decky loader themes

* **(⚠️ WIP) Proton (Glorious Eggroll)**:
    * Supports/installs `proton-ge-updater`

* **(⚠️ WIP) Console Graphics:**
    * Defaults to using proprierary nvidia graphics.
        * Currenlty only supports `maxwell` architectures
        * With `nouveau` blacklisted

### Console Profile Environent

| Environment     | Value                        |
|-----------------|------------------------------|
| `DRIVER_STACK`  | `amd` \| `intel` \| `nvidia` | 
| `SESSION_TYPE`  | `x11`  \| `wayland` |
| `PROTON_GE`     | `true` \| `false` |
| `DECKY`         | `true` \| `false` |

### Console Profile Performance

* **`config/gaming.mk`**: Contains configurations for console gaming performance

Compile a minimal base system, an ISO configured for couch console play, or compile a minimal desktop system ISO:

    make

* **`make depends`**: Install needed build dependencies.

* **`make clean`**: Purges the work directory.
	* **`make cleanbuilds`**: For a clean build.

* **See `make help` for more information**

## (⚠️ WIP) Flashing / Installing

* All installation configuration options are stored in `config/install.mk`

* **`make install`**: Is intended to install to a configured USB drive 
* **`make install-dvd`**: Is a placeholder for installing to a configured DVD

## Booting The Target Profile

* Insert the newly flashed USB/DVD into the target hardware
* Power on the machine
* Boot USB/DVD
    * Enter the BIOS/UEFI boot menu
    * Select the USB/DVD drive as the primary boot device
* Step back
    * **⚠️**

---

### 🌐 Remote Management (Cockpit)

Once the automated installation is complete, you can manage the system remotely without interrupting the standalone gaming session.

Open a web browser on another device on the local network:

    http://<target-host-ip>:<`COCKPIT_PORT`>

Log in using the admin account credentials to handle updates, storage, or access a root shell.
(`COCKPIT_PORT` defaults to `9090`)

### ⚠️ WARNING: This is a zero-touch, fully unattended installer. The moment you boot the machine from this USB drive, the configuration will automatically wipe the primary disk and install the OS without asking for any confirmation. Do not boot this on a machine containing data you wish to keep.

(Also, for `steamdeck` devices, shouldn't all documents be called deckuments?)

### License

GPL-3.0 (see LICENSE).
