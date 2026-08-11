# Debian Build System: Alienware X51 R3

This repository provides an automated `Makefile` and Debian 13 (Trixie) preseed and ansible build system to generate custom, static ISO images tailored specifically for the Alienware X51 R3 hardware architecture.

## Exhaustive Hardware Targeting

This build is engineered to cover the complete range of component options for the Alienware X51 R3 motherboard (Intel Z170 chipset):

* **Processors (CPU):** 6th-Generation Skylake CPUs
    * including the Intel Core i3
    * i5-6400
    * i5-6600K
    * and i7-6700K

* The kernel command line applies `mitigations=off` to recover performance lost to CPU side-channel patches.

* **Graphics (GPU):** Nvidia Maxwell architecture cards
    * GeForce GTX 745
    * GTX 960
    * GTX 970
    * as well as integrated Intel HD Graphics
    
* Proprietary Nvidia setups enforce `nvidia-drm.modeset=1` and blacklist the open-source driver.

* **Networking:** Intel Wireless Wi-Fi
    * Intel 3165 802.11ac chipset 
    * supported natively via pre-baked `firmware-iwlwifi` and `firmware-realtek`.

* **Audio:** Realtek ALC892 High Definition Audio codec.

* **Storage:** Support for M.2 NVMe SSDs and standard 3.5-inch SATA hard drives.

* **Optical Drive:** Internal slot-loading DVD/Blu-ray combo drives.

* **Lighting:** AlienFX case lighting system, pre-equipped with `i2c-tools` and `python3-pip` for community lighting utilities (e.g., `alienfx-tools`).

## Modular Build Architecture

* **`make console`**: Compiles an ISO configured for living-room console play. It forces X11 via SDDM, installs the proprietary Nvidia driver stack, adds Blu-ray decryption tools (`libaacs0`, `libbdplus0`), provisions native Steam, and initializes a standalone Big Picture session.

* **`make desktop`**: Compiles a lightweight desktop ISO utilizing Wayland and open-source Nouveau drivers.

* **`make clean`**: Purges all temporary work directories and built ISO artifacts.

## Standalone Console Mode & System Updates

* **Standalone Session:** In console mode.
    * Standard desktop environments are bypassed entirely.
    * SDDM launches a custom desktop session defined at `/usr/share/xsessions/steam-session.desktop`, executing `/usr/local/bin/steam-session.sh`.
        * This script suppresses screen blanking
        * injects Feral GameMode (`gamemoderun`)
        * Passes arguments (`-tenfoot -steamos`) to Steam.

* **SteamOS Update Button:** Because Steam is invoked with `-steamos`, Big Picture Mode enables the "Update System" interface button.
    * This links directly to `/usr/bin/steamos-update`, which automatically runs `apt-get upgrade` and updates any local Flatpaks in the background.

## Usage Instructions

# ⚠️ (NEEDS WORK)
* **Configuration**
    * Specify configuration system
    * Specify configuration environment/variables
    * Specify default build target configuration files
    * Specify user configuration override config
        * (This should be the default behaviour, expanded)
* **Building**
    * A shit show
    * Maybe add a third build target like `base` for a minimal base system
        * Might make things easier
        * Maybe this should be the default build target, instead of help? Nahh.
* **Flashing ...**
    * Add make build targets for dvd and iso "installation"
        * `make install` to either a dvd or usb 
    * Add updated instruction for ISO and also DVD installation
        * Using `make install`
    * Add instruction for ChromeOS devices

---

### Configuration

* `desktop.mk` for desktop configuration
* `console.mk` for a console like configuration
* `debian.mk` to update debian related configuration

### Building

* **Build Console ISO:** Run `make console`
* **Build Desktop ISO:** `make desktop`
* **Clean Artifacts:** `make clean`

Run `make` or `make help` for a brief summary.

### Flashing to a USB Drive

Write this ISO to a USB drive using `dd`. (Replace `/dev/sdX` with your actual USB drive target, `e.g., /dev/sdb`.)

    sudo dd if=debian-custom-unattended.iso of=/dev/sdX bs=4M status=progress

## Booting the Target Console

* Insert the newly flashed USB drive into your target hardware.
* Power on the machine and enter the BIOS/UEFI boot menu.
* Select the USB drive as the primary boot device.
* Step back.

---

⚠️ WARNING: This is a zero-touch, fully unattended installer. The moment you boot the machine from this USB drive, the configuration will automatically wipe the primary disk (/dev/sda) and install the OS without asking for any confirmation. Do not boot this on a machine containing data you wish to keep!

🌐 Remote Management (Cockpit)
Once the automated installation is complete, you can manage the system remotely without interrupting the standalone gaming session.

Open a web browser on another device on the local network:

    https://<target-machine-ip>:<COCKPIT_PORT>

Log in using the admin account credentials to handle updates, storage, or access a root shell.
(<COCKPIT_PORT> defaults to `9090`)
  