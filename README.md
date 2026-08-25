# Debian Build System: Alienware X51 R3

This repository provides an automated `Makefile`, Debian 13 (Trixie) preseed,
and ansible build system to generate custom, static ISO images.
Tailored specifically for the Alienware X51 R3 hardware architecture.

#### ⚠️ WIP

## Exhaustive Hardware Targeting

This build is Trying to cover the complete range of component options for the Alienware X51 R3 motherboard (Intel Z170 chipset):

* **Processors (CPU):** 6th-Generation Skylake CPUs
    * including the Intel Core i3
    * i5-6400
    * i5-6600K
    * and i7-6700K

* **Graphics (GPU):** Nvidia Maxwell architecture cards
    * GeForce GTX 745
    * GTX 960
    * GTX 970
    * as well as integrated Intel HD Graphics

* (Proprietary Nvidia setups enforce `nvidia-drm.modeset=1` and blacklist the open-source driver.)

* **Networking:** Intel Wireless Wi-Fi
    * Intel 3165 802.11ac chipset 
    * supported natively via pre-baked `firmware-iwlwifi` and `firmware-realtek`.

* **Audio:** Realtek ALC892 High Definition Audio codec.

* **Storage:** Support for M.2 NVMe SSDs and standard 3.5-inch SATA hard drives.

* **Optical Drive:** Internal slot-loading DVD/Blu-ray combo drives.

* **Lighting:** AlienFX case lighting system, pre-equipped with `i2c-tools` and `python3-pip` for community lighting utilities (e.g., `alienfx-tools`).

## Targets

### Base

#### ⚠️ WIP

### Desktop

#### ⚠️ WIP

* (wayland?)

### Console

* **Standalone Session:**
    * Standard desktop environments are bypassed entirely
    * SDDM launches a custom desktop session
        * This script suppresses screen blanking
        * injects Feral GameMode (`gamemoderun`)
        * Passes arguments (`-tenfoot -steamos`) to Steam

* **SteamOS Update Button:**
    * Steam is invoked with `-steamos`
        * Big Picture Mode enables the "Update System" interface button
    * This links directly to `/usr/bin/steamos-update`
        * Automatically updates any debian packages in the background
            * apt
            * flatpak
            * snap (for some reason) (WIP)

* **Decky loader**:
    * Support for installing decky loader (WIP)
    * Support for installing decky loader themes (WIP)

* **Proton (Glorious Eggroll)**:
    * Supports/installs `proton-ge-updater`

## Usage Instructions

Compile a minimal base system, an ISO configured for living-room console play, provisions native Steam, and initializes a standalone Big Picture session, or compile a minimal desktop system ISO.

    make

* **`make depends`**: Install needed build dependencies.

* **`make clean`**: Purges all work directories and build artifacts.

* **See `make help` for more information**

### Profile Settings

#### ⚠️ WIP

* (explain config.mk)
* (explain TARGET)
* (explain TARGET configuration profiles)

## Profile Configuration Settings

#### ⚠️ WIP

* (explain make configuration system)
* (explain configuration variables)
* (explain make configuration files)
    * `base.mk`
    * `desktop.mk`
    * `console.mk`
    * `debian.mk`
    * ...

### Flashing to a USB Drive

#### ⚠️ WIP
---
* Add make build targets for dvd and iso "installation"
    * `make install` to either a dvd or usb 
    * `install.mk`
        * `USB` variable
        * `DVD` variable
        * `make install USB=...`

* Add updated instruction for ISO and also DVD installation
    * Using `make install`
    * ...

* Add instruction for ChromeOS devices

## Booting the Target Console

* Insert the newly flashed USB drive into your target hardware.
* Power on the machine and enter the BIOS/UEFI boot menu.
* Select the USB drive as the primary boot device.
* Step back.
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

## License

GPL-3.0 (see LICENSE).
