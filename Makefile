# Makefile for Dynamic Debian Preseed & ISO Repacking

# ==========================================
# Variables & Defaults
# ==========================================
ISO_URL      := https://cdimage.debian.org/cdimage/weekly-builds/amd64/iso-cd/debian-testing-amd64-netinst.iso
ISO_FILE     := debian-netinst.iso
ISO_CUSTOM   := debian-custom-unattended.iso

# Default Packages
PKG_UTILS    := sudo efibootmgr vim nano wget curl git ufw apparmor apparmor-profiles
PKG_NET      := net-tools network-manager
PKG_DESKTOP  := gnome-core gdm3
BASE_PKGS    := $(PKG_UTILS) $(PKG_NET) $(PKG_DESKTOP)

# Default Partitioning (/ and /home only)
PART_BASE    := 1126 1126 1126 free \$$iflabel{ gpt } \$$reusemethod{ } method{ efi } format{ } . 16486 16486 16486 linux-swap method{ swap } format{ } . 31846 31846 31846 ext4 method{ format } format{ } use_filesystem{ } filesystem{ ext4 } mountpoint{ / } . 100 10000 -1 ext4 method{ format } format{ } use_filesystem{ } filesystem{ ext4 } mountpoint{ /home } .

# Default Late Command (Secure admin environment)
LATE_BASE    := in-target ufw --force enable;

# ==========================================
# Gaming Configuration Overrides (Intel i5 + Arch/Debian Tuning)
# ==========================================
# KDE, Nvidia DKMS, Intel tuning, GameMode, and Flatpak
PKG_GAMING   := plasma-desktop sddm nvidia-kernel-dkms nvidia-driver \
                intel-microcode thermald cpufrequtils gamemode flatpak

# The massive Late Command injection:
# 1. Adds 'gamer' user
# 2. Intel CPU & I/O Tuning
# 3. UFW & AppArmor enforcement
# 4. Silent Boot GRUB modifications
# 5. Flatpak Steam & Big Picture Autostart
LATE_GAMING  := in-target useradd -m -G audio,video,netdev -s /bin/bash gamer; \
                in-target systemctl enable thermald; \
                in-target bash -c "echo 'GOVERNOR=\"performance\"' > /etc/default/cpufrequtils"; \
                in-target systemctl restart cpufrequtils; \
                in-target bash -c "echo 'ACTION==\"add|change\", KERNEL==\"sd[a-z]|nvme[0-9]*\", ATTR{queue/rotational}==\"0\", ATTR{queue/scheduler}=\"mq-deadline\"' > /etc/udev/rules.d/60-iosched.rules"; \
                in-target sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet"/GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=3 systemd.show_status=auto rd.udev.log_level=3 vt.global_cursor_default=0 mitigations=off"/g' /etc/default/grub; \
                in-target update-grub; \
                in-target flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo; \
                in-target flatpak install -y flathub com.valvesoftware.Steam; \
                in-target bash -c "mkdir -p /home/gamer/.config/autostart && echo -e '[Desktop Entry]\nExec=flatpak run com.valvesoftware.Steam -tenfoot\nType=Application\nName=Steam Big Picture' > /home/gamer/.config/autostart/steam.desktop"; \
                in-target chown -R gamer:gamer /home/gamer;

# ==========================================
# Target State Variables (Modified by targets)
# ==========================================
TARGET_PKGS  = $(BASE_PKGS)
TARGET_PART  = $(PART_BASE)
TARGET_LATE  = $(LATE_BASE)

# ==========================================
# Make Targets
# ==========================================
.PHONY: all default gaming generate download repack clean

all: default

# The default target uses base GNOME configuration
default: generate

# The gaming target overrides the desktop and appends gaming tweaks
gaming: TARGET_PKGS := $(PKG_UTILS) $(PKG_NET) $(PKG_GAMING)
gaming: TARGET_LATE := $(LATE_BASE) $(LATE_GAMING)
gaming: generate

# Generates the final preseed.cfg using sed substitutions
generate:
	@echo "=> Injecting parameters into preseed.cfg..."
	@sed -e 's|@@PARTITION_RECIPE@@|$(TARGET_PART)|g' \
	     -e 's|@@PACKAGES@@|$(TARGET_PKGS)|g' \
	     -e 's|@@LATE_COMMAND@@|$(TARGET_LATE)|g' \
	     preseed.cfg.template > preseed.cfg
	@echo "=> preseed.cfg generated successfully."

# Downloads the Debian netinst ISO
download:
	@if [ ! -f $(ISO_FILE) ]; then \
		echo "=> Downloading Debian ISO..."; \
		wget -O $(ISO_FILE) $(ISO_URL); \
	fi

# Repacks the ISO with the newly generated preseed.cfg
repack: download generate
	@echo "=> Extracting base ISO..."
	@mkdir -p isodir
	@bsdtar -C isodir -xf $(ISO_FILE)
	@chmod -R +w isodir
	
	@echo "=> Injecting preseed.cfg and updating GRUB..."
	@cp preseed.cfg isodir/preseed.cfg
	@sed -i 's/append vga=788 initrd=\/install.amd\/initrd.gz/append vga=788 initrd=\/install.amd\/initrd.gz auto=true priority=critical preseed\/file=\/cdrom\/preseed.cfg/' isodir/isolinux/txt.cfg
	@sed -i 's/--- quiet/--- quiet auto=true priority=critical preseed\/file=\/cdrom\/preseed.cfg/' isodir/boot/grub/grub.cfg
	
	@echo "=> Repacking into $(ISO_CUSTOM)..."
	@xorriso -as mkisofs -r -V "DEBIAN_CUSTOM" \
		-J -joliet-long -b isolinux/isolinux.bin \
		-c isolinux/boot.cat -no-emul-boot \
		-boot-load-size 4 -boot-info-table \
		-eltorito-alt-boot -e boot/grub/efi.img \
		-no-emul-boot -isohybrid-gpt-basdat -isohybrid-apm-hfsplus \
		-o $(ISO_CUSTOM) isodir
	@echo "=> Done! Burn $(ISO_CUSTOM) to your USB drive."

clean:
	rm -rf isodir preseed.cfg $(ISO_CUSTOM)