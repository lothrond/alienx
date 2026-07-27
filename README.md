# 💿 Debian Automated ISO Builder

A streamlined, template-driven build system for generating fully unattended, custom Debian (Trixie) installation images. 

This project uses `make` and `sed` to dynamically inject partitioning schemes, software packages, and post-installation automation into a Debian `preseed.cfg`. It then automatically downloads, modifies, and repacks a bootable ISO for a true zero-touch installation.

---

## ✨ Features

* **Dynamic Preseed Generation:** Keeps your configuration modular by separating logic from the preseed syntax using a `preseed.cfg.template`.
* **Dual Deployment Profiles:**
  * **Standard Desktop:** Deploys a baseline GNOME desktop, standard disk partitioning (separate `/` and `/home`), and essential networking utilities.
  * **Gaming Console:** Swaps GNOME for KDE Plasma, installs proprietary Nvidia DKMS drivers, applies CPU performance tuning, and automatically deploys Steam inside a Flatpak sandbox to keep host runtimes clean.
* **Automated ISO Repacking:** Automatically downloads the latest Debian `netinst` ISO, injects the preseed file, modifies GRUB and ISOLINUX for strict silent booting, and repacks the hybrid ISO.

---

## 🛠️ Prerequisites

To generate the custom ISO, your host build machine must have a few standard archiving and compilation tools installed. 

On a Debian-based host, install the following dependencies:

```bash
sudo apt update &&
sudo apt install make wget sed libarchive-tools xorriso

## 🚀 Usage Instructions

Clone this repository or ensure both the Makefile and preseed.cfg.template are in your working directory.

Build the Standard Desktop ISO.
To generate a standard Debian environment with GNOME and baseline utilities:

    # Generate the standard preseed.cfg
    make default

    # Download, extract, inject, and repack the ISO
    make repack

Build the Gaming Console ISO.
To generate the performance-tuned gaming environment with KDE, Nvidia drivers, and Steam:

    # Generate the gaming-optimized preseed.cfg
    make gaming

    # Download, extract, inject, and repack the ISO
    make gaming repack

Clean the Build Environment.
To remove downloaded ISOs, extracted directories, and generated configuration files:

    make clean

📂 Project Structure
`Makefile:` The core build engine. It manages variables, downloads the base Debian ISO, handles sed string substitutions, and orchestrates the `xorriso` repacking.

`preseed.cfg.template:` The skeleton Debian installer configuration file contains `@@PLACEHOLDERS@@`
that the Makefile targets and replaces during the build phase.

💾 Installation onto Target Hardware
Once the build finishes, you will find a new file named `debian-custom-unattended.iso` in your directory.

Flash this ISO to a USB drive using dd, cat, cp, Rufus, BalenaEtcher, etc:

    # Example using dd (Replace /dev/sdX with your actual USB drive target)
    sudo dd if=debian-custom-unattended.iso of=/dev/sdX bs=4M status=progress

⚠️ WARNING: This is a zero-touch, fully automated installer. Once you boot a machine from this USB drive, it will automatically wipe the primary disk (/dev/sda) and begin the installation without asking for confirmation. Do not boot this on a machine containing data you wish to keep!