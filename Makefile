# Makefile for Dynamic Debian Preseed & ISO Repacking

# ==========================================
# Variables & Defaults
# ==========================================
ISO_URL      := https://cdimage.debian.org/cdimage/weekly-builds/amd64/iso-cd/debian-testing-amd64-netinst.iso
ISO_FILE     := debian-netinst.iso
ISO_CUSTOM   := debian-custom-unattended.iso

# Default Packages (GNOME, Net tools, Utils)
PKG_UTILS    := sudo efibootmgr vim nano wget curl git
PKG_NET      := net-tools network-manager
PKG_DESKTOP  := gnome-core gdm3
BASE_PKGS    := $(PKG_UTILS) $(PKG_NET) $(PKG_DESKTOP)

# Default Partitioning (/ and /home only)
# Note: $$ escapes to $ for sed.
PART_BASE    := 1126 1126 1126 free \$$iflabel{ gpt } \$$reusemethod{ } method{ efi } format{ } . 16486 16486 16486 linux-swap method{ swap } format{ } . 31846 31846 31846 ext4 method{ format } format{ } use_filesystem{ } filesystem{ ext4 } mountpoint{ / } . 100 10000 -1 ext4 method{ format } format{ } use_filesystem{ } filesystem{ ext4 } mountpoint{ /home } .

# Default Late Command (Just secure admin environment)
LATE_BASE    := in-target ufw enable;

# ==========================================
# Gaming Configuration Overrides
# ==========================================
# Swaps GNOME for KDE, adds Nvidia DKMS, power tuning, and Flatpak
PKG_GAMING   := plasma-desktop sddm nvidia-kernel-dkms nvidia-driver cpufrequtils flatpak

# Gaming Late Command (Adds 'gamer' user, sets up Flatpak Steam)
LATE_GAMING  := in-target useradd -m -s /bin/bash gamer; \
                in-target flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo; \
                in-target flatpak install -y flathub com.valvesoftware.Steam; \
                in-target systemctl enable cpufrequtils;

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