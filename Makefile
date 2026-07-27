# Makefile for Dynamic Debian Preseed & ISO Repacking
.ONESHELL:

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

# ==========================================
# Script Definitions (Written to setup.sh)
# ==========================================
define SCRIPT_BASE
#!/bin/bash
# Standard Admin Setup
ufw --force enable
endef

define SCRIPT_GAMING
#!/bin/bash
# Secure baseline
ufw --force enable

# Gaming & Performance additions (Intel i5 & SteamOS behavior)
useradd -m -G audio,video,netdev -s /bin/bash gamer
systemctl enable thermald
echo 'GOVERNOR="performance"' > /etc/default/cpufrequtils
systemctl restart cpufrequtils
echo 'ACTION=="add|change", KERNEL=="sd[a-z]|nvme[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"' > /etc/udev/rules.d/60-iosched.rules
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet"/GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=3 systemd.show_status=auto rd.udev.log_level=3 vt.global_cursor_default=0 mitigations=off"/g' /etc/default/grub
update-grub
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub com.valvesoftware.Steam
mkdir -p /home/gamer/.config/autostart
echo -e '[Desktop Entry]\nExec=flatpak run com.valvesoftware.Steam -tenfoot\nType=Application\nName=Steam Big Picture' > /home/gamer/.config/autostart/steam.desktop
chown -R gamer:gamer /home/gamer
endef

# ==========================================
# Gaming Configuration Overrides
# ==========================================
PKG_GAMING   := plasma-desktop sddm nvidia-kernel-dkms nvidia-driver \
                intel-microcode thermald cpufrequtils gamemode flatpak

# ==========================================
# Target State Variables
# ==========================================
TARGET_PKGS   = $(BASE_PKGS)
TARGET_PART   = $(PART_BASE)
TARGET_SCRIPT = $(SCRIPT_BASE)

# Simplified Late Command: just copy and execute the script natively.
LATE_CMD = cp /cdrom/setup.sh /target/root/setup.sh; in-target chmod +x /root/setup.sh; in-target /bin/bash /root/setup.sh

# ==========================================
# Make Targets
# ==========================================
.PHONY: all default gaming generate download repack clean

all: default

default: generate

gaming: TARGET_PKGS := $(PKG_UTILS) $(PKG_NET) $(PKG_GAMING)
gaming: TARGET_SCRIPT := $(SCRIPT_GAMING)
gaming: generate

generate:
	@echo "=> Injecting parameters into preseed.cfg..."
	@sed -e 's|@@PARTITION_RECIPE@@|$(TARGET_PART)|g' \
	     -e 's|@@PACKAGES@@|$(TARGET_PKGS)|g' \
	     -e 's|@@LATE_COMMAND@@|$(LATE_CMD)|g' \
	     preseed.cfg.template > preseed.cfg
	@echo "=> Generating setup.sh..."
	@cat << 'EOF' > setup.sh
$(TARGET_SCRIPT)
EOF
	@echo "=> preseed.cfg and setup.sh generated successfully."

download:
	@if [ ! -f $(ISO_FILE) ]; then \
		echo "=> Downloading Debian ISO..."; \
		wget -O $(ISO_FILE) $(ISO_URL); \
	fi

repack: download generate
	@echo "=> Extracting base ISO..."
	@mkdir -p isodir
	@bsdtar -C isodir -xf $(ISO_FILE)
	@chmod -R +w isodir
	
	@echo "=> Injecting preseed.cfg, setup.sh, and updating GRUB..."
	@cp preseed.cfg isodir/preseed.cfg
	@cp setup.sh isodir/setup.sh
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
	rm -rf isodir preseed.cfg setup.sh $(ISO_CUSTOM)