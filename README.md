# 💿 Debian Automated ISO Builder (Native SteamOS/Console Edition)

A streamlined, template-driven build system for generating fully unattended, custom Debian 13 (Trixie) installation images. 

This build utilizes hardware-abstraction variables to rapidly deploy a pure 64-bit administrative desktop, or a 32-bit injected, native SteamOS-like console environment complete with `gamescope` and a standalone Wayland/X11 session.

---

## ✨ Features

* **Hardware Agnostic Templating:** Inject specific Intel/AMD microcode and Nvidia/Radeon driver stacks directly via `make` variables.
* **Native 32-bit Multiarch Support:** The gaming profile automatically configures `dpkg` for `i386` and installs native Linux 32-bit libraries required for Steam and Proton.
* **Standalone Steam Session:** Bypasses heavy Desktop Environments (like GNOME/KDE) entirely. SDDM auto-logs the `gamer` user into a custom `gamescope` + `openbox` X11 session for maximum resource availability.
* **Zero-Touch Configuration:** The root account is explicitly disabled. The `admin` user handles all `sudo` tasks, while the `gamer` user is restricted and stripped of a password via PAM for true passwordless authentication.
* **RHEL-Style Remote Management:** Installs and configures Cockpit with a dynamic port, allowing full system administration via a web UI.

---

## 🛠️ Prerequisites

To generate the custom ISO, your host build machine must have standard archiving and compilation tools installed. 

On a Debian/Ubuntu-based host:

    sudo apt update
    sudo apt install make wget sed libarchive-tools xorriso

## 🚀 Usage Instructions

You can pass configuration variables directly to the `make` command to tailor the Wi-Fi credentials,`passwords, and disk layout at build time.

### Build Variables

* `CPU_VENDOR`: `intel` (default) or `amd`. (Adjusts microcode and thermald).
* `GPU_VENDOR`: `nvidia-maxwell` (default) or `amd`. (Adjusts 64/32-bit driver stacks).
* `WIFI_SSID`: Your wireless network name.
* `WIFI_PASS`: Your wireless network password.
* `ADMIN_PASS`: Password for the admin user (who has sudo access).
* `GAMER_PASS`: Password for the gamer user (auto-logged in).
* `COCKPIT_PORT`: Network port for the web-based admin interface (Defaults to `9090`).
** `PART`: Partitioning scheme.
Options are auto, home (default), or multi.
    * `auto`: 1GB Boot, 15GB Swap, Max /.
    * `home`: 1GB Boot, 15GB Swap, 15GB /, Max /home.
    * `multi`: 1GB Boot, 15GB Swap, 15GB /, 15GB /usr, 10GB /var, Max /home.

### Build a Standard Desktop ISO

Build the Standard Desktop ISO (Pure 64-bit):
(Generates a 64-bit only Debian environment with GNOME and Cockpit. No multiarch, no 32-bit libraries.)

    make repack ADMIN_PASS="securepass" PART=home

Build the Gaming Console ISO (Native Steam + Gamescope):
(Generates the performance-tuned gaming environment with a standalone session, SDDM, Gamescope, and 32-bit architecture enabled.)

    make gaming repack \
        CPU_VENDOR="intel" \
        GPU_VENDOR="nvidia-maxwell" \
        WIFI_SSID="MyWifi" \
        WIFI_PASS="Secret123" \
        ADMIN_PASS="securepass" \
        GAMER_PASS="nopass" \
        COCKPIT_PORT="8443" \
        PART=multi

Clean the Build Environment:

    make clean

## 💾 Installation onto Target Hardware

The build produces a bootable ISO file named `debian-custom-unattended.iso` in your working directory.

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
(<COCKPIT-PORT> defaults to `9090`)
