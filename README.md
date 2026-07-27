# 💿 Debian Automated ISO Builder (SteamOS/Console Edition)

A streamlined, template-driven build system for generating fully unattended, custom Debian 13 (Trixie) installation images. 

This project uses `make` and `sed` to dynamically inject partitioning schemes, software packages, network configurations, and aggressive performance automation into a Debian `preseed.cfg`. 

---

## ✨ Features

* **Dynamic Preseed Generation:** Keeps the configuration modular by separating logic from the preseed syntax using a `preseed.cfg.template`.

* **Zero-Touch Network & User Setup:** Injects NetworkManager Wi-Fi profiles and handles `admin` and `gamer` passwords securely during the late-command phase.

* **Dual Deployment Profiles:**
  * **Standard Desktop:** Deploys a baseline GNOME desktop, standard disk partitioning, essential networking utilities, auto-login for GNOME (GDM3), and disables the GNOME lock screen.
  * **Gaming Console (SteamOS Clone):** Swaps GNOME for KDE Plasma, installs proprietary Nvidia DKMS drivers, sets up SDDM auto-login, and fully disables KDE's `kscreenlocker`.

### 🎮 The "Gaming" Profile Enhancements
When building with the `gaming` target, the ISO applies the following optimizations recommended by the Arch Wiki and Debian performance standards:

1. **Intel i5 Architecture Tuning:**
   * Installs `intel-microcode` for CPU stability.
   * Enables `thermald` to manage thermal states and prevent premature CPU throttling.
   * Forces `cpufrequtils` to run the CPU governor in `performance` mode to eliminate micro-stutters.
2. **Kernel & System Overrides:**
   * Disables CPU security mitigations (`mitigations=off`) to claw back CPU overhead.
   * Forces PCIe Active State Power Management (`pcie_aspm=force`).
   * Sets the disk I/O scheduler to `mq-deadline` via a `udev` rule to prioritize game asset streaming.
3. **True Silent Boot:**
   * Overwrites GRUB to hide systemd text, suppress kernel logging, hide udev events, and disable the blinking cursor.
   * Triggers `nvidia-drm.modeset=1` for proper Wayland/X11 compositing transitions.
4. **X11 / Nvidia Rendering Tweaks (Via Autostart Script):**
   * Uses `unclutter` to hide the mouse cursor instantly on login for a console-like feel.
   * Suspends the KDE KWin compositor via D-Bus (`qdbus`) to eliminate X11 tearing and free up GPU overhead.
   * Exports `__GL_THREADED_OPTIMIZATIONS=1` and `__GL_SYNC_TO_VBLANK=0` directly to the Steam runtime.
5. **Sandboxed Steam Engine:**
   * Installs Steam via Flatpak to keep 32-bit libraries and dependencies out of the host OS root.
   * Overrides Flatpak permissions to allow Steam to inhibit screensavers and power management (`org.freedesktop.ScreenSaver` & `PowerManagement`).
   * Generates a `.desktop` entry to automatically launch Steam in Big Picture mode (`-tenfoot`).

---

## 🛠️ Prerequisites

To generate the custom ISO, your host build machine must have standard archiving and compilation tools installed. 

On a Debian (based) host:

    sudo apt update
    sudo apt install make wget sed libarchive-tools xorriso

## 🚀 Usage Instructions

You can pass configuration variables directly to the `make` command to tailor the Wi-Fi credentials,`passwords, and disk layout at build time.

### Build Variables

* `WIFI_SSID`: Your wireless network name.
* `WIFI_PASS`: Your wireless network password.
* `ADMIN_PASS`: Password for the admin user (who has sudo access).
* `GAMER_PASS`: Password for the gamer user (auto-logged in).
** `PART`: Partitioning scheme.
Options are auto, home (default), or multi.
    * `auto`: 1GB Boot, 15GB Swap, Max /.
    * `home`: 1GB Boot, 15GB Swap, 15GB /, Max /home.
    * `multi`: 1GB Boot, 15GB Swap, 15GB /, 15GB /usr, 10GB /var, Max /home.

### Build a Standard Desktop ISO

Generates a standard Debian environment with GNOME.

    make repack WIFI_SSID="MyWifi" WIFI_PASS="Secret123" ADMIN_PASS="securepass" GAMER_PASS="nopass" PART=home

### Build a Gaming Console ISO

Generates the performance-tuned gaming environment with KDE, Nvidia drivers, and Steam.

    make gaming repack WIFI_SSID="MyWifi" WIFI_PASS="Secret123" ADMIN_PASS="securepass" GAMER_PASS="nopass" PART=multi

### Clean the Build Environment

Removes downloaded ISOs, extracted directories, and generated configuration files.

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