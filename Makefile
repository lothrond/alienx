# Makefile for Dynamic Debian Preseed & ISO Repacking
.ONESHELL:

# ==========================================
# Variables & Defaults
# ==========================================
ISO_URL      := https://cdimage.debian.org/cdimage/weekly-builds/amd64/iso-cd/debian-testing-amd64-netinst.iso
ISO_FILE     := debian-netinst.iso
ISO_CUSTOM   := debian-custom-unattended.iso

# User Credentials & Network (Override via CLI, e.g., make gaming WIFI_SSID="My Net" WIFI_PASS="1234")
WIFI_SSID    ?= default_ssid
WIFI_PASS    ?= default_pass
ADMIN_PASS   ?= admin
GAMER_PASS   ?= gamer

# Default Packages
PKG_UTILS    := sudo efibootmgr vim nano wget curl git ufw apparmor apparmor-profiles
PKG_NET      := net-tools network-manager
PKG_DESKTOP  := gnome-core gdm3
BASE_PKGS    := $(PKG_UTILS) $(PKG_NET) $(PKG_DESKTOP)

# ==========================================
# Script Definitions (Written to setup.sh)
# ==========================================
define SCRIPT_BASE
#!/bin/bash
ufw --force enable

# Passwords
echo "admin:@@ADMIN_PASS@@" | chpasswd
useradd -m -G audio,video,netdev -s /bin/bash gamer
echo "gamer:@@GAMER_PASS@@" | chpasswd

# NetworkManager Wi-Fi Injection
cat << 'NM_EOF' > /etc/NetworkManager/system-connections/Wifi.nmconnection
[connection]
id=@@WIFI_SSID@@
type=wifi
[wifi]
mode=infrastructure
ssid=@@WIFI_SSID@@
[wifi-security]
key-mgmt=wpa-psk
psk=@@WIFI_PASS@@
[ipv4]
method=auto
[ipv6]
method=auto
NM_EOF
chmod 600 /etc/NetworkManager/system-connections/Wifi.nmconnection

# GNOME Auto-login & Lock Screen Bypass
sed -i 's/#  AutomaticLoginEnable = true/AutomaticLoginEnable = true/g' /etc/gdm3/daemon.conf
sed -i 's/#  AutomaticLogin = user1/AutomaticLogin = gamer/g' /etc/gdm3/daemon.conf
su - gamer -c "mkdir -p ~/.config/dconf; dconf write /org/gnome/desktop/screensaver/lock-enabled false" || true
endef

define SCRIPT_GAMING
#!/bin/bash
ufw --force enable

# User & Passwords
echo "admin:@@ADMIN_PASS@@" | chpasswd
useradd -m -G audio,video,netdev -s /bin/bash gamer
echo "gamer:@@GAMER_PASS@@" | chpasswd

# NetworkManager Wi-Fi Injection
cat << 'NM_EOF' > /etc/NetworkManager/system-connections/Wifi.nmconnection
[connection]
id=@@WIFI_SSID@@
type=wifi
[wifi]
mode=infrastructure
ssid=@@WIFI_SSID@@
[wifi-security]
key-mgmt=wpa-psk
psk=@@WIFI_PASS@@
[ipv4]
method=auto
[ipv6]
method=auto
NM_EOF
chmod 600 /etc/NetworkManager/system-connections/Wifi.nmconnection

# Intel & Performance Tuning
systemctl enable thermald
echo 'GOVERNOR="performance"' > /etc/default/cpufrequtils
systemctl restart cpufrequtils
echo 'ACTION=="add|change", KERNEL=="sd[a-z]|nvme[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"' > /etc/udev/rules.d/60-iosched.rules
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet"/GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=3 systemd.show_status=auto rd.udev.log_level=3 vt.global_cursor_default=0 mitigations=off nvidia-drm.modeset=1 pcie_aspm=force"/g' /etc/default/grub
update-grub

# Steam Flatpak Deployment & Overrides
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub com.valvesoftware.Steam
su - gamer -c "flatpak override --user --talk-name=org.freedesktop.ScreenSaver com.valvesoftware.Steam"
su - gamer -c "flatpak override --user --talk-name=org.freedesktop.PowerManagement com.valvesoftware.Steam"
su - gamer -c "flatpak override --user --env=ENABLE_GAMESCOPE_WINE_WORKAROUND=1 com.valvesoftware.Steam"

# SDDM Auto-login (KDE)
mkdir -p /etc/sddm.conf.d
echo -e "[Autologin]\nUser=gamer\nSession=plasma" > /etc/sddm.conf.d/autologin.conf

# KDE Lock Screen Bypass
su - gamer -c "mkdir -p ~/.config && echo -e '[Daemon]\nAutolock=false\nLockOnResume=false' > ~/.config/kscreenlockerrc"

# Advanced X11/Nvidia Autostart Script & unclutter
mkdir -p /home/gamer/.local/bin
mkdir -p /home/gamer/.config/autostart

cat << 'STEAM_SCRIPT' > /home/gamer/.local/bin/start-steam.sh
#!/bin/bash
STEAM_OPTS="-tenfoot"
export __GL_THREADED_OPTIMIZATIONS=1
export __GL_YIELD="USLEEP"
export __GL_SYNC_TO_VBLANK=0
export VDPAU_DRIVER="nvidia"

unclutter -idle 0.01 -root &
qdbus org.kde.KWin /Compositor suspend || true
exec flatpak run com.valvesoftware.Steam $$STEAM_OPTS
STEAM_SCRIPT

chmod +x /home/gamer/.local/bin/start-steam.sh

cat << 'DESKTOP_ENTRY' > /home/gamer/.config/autostart/steam.desktop
[Desktop Entry]
Exec=/home/gamer/.local/bin/start-steam.sh
Type=Application
Name=Steam Big Picture Console Mode
Terminal=false
DESKTOP_ENTRY

chown -R gamer:gamer /home/gamer
endef

# ==========================================
# Partitioning Recipes (Sizes in MB)
# ==========================================
# 1. AUTO (Atomic): 1GB Boot, 15GB Swap, Max /
PART_AUTO  := 1024 1024 1024 free \$$iflabel{ gpt } \$$reusemethod{ } method{ efi } format{ } . 15360 15360 15360 linux-swap method{ swap } format{ } . 100 10000 -1 ext4 method{ format } format{ } use_filesystem{ } filesystem{ ext4 } mountpoint{ / } .

# 2. HOME (Default): 1GB Boot, 15GB Swap, 15GB /, Max /home
PART_HOME  := 1024 1024 1024 free \$$iflabel{ gpt } \$$reusemethod{ } method{ efi } format{ } . 15360 15360 15360 linux-swap method{ swap } format{ } . 15360 15360 15360 ext4 method{ format } format{ } use_filesystem{ } filesystem{ ext4 } mountpoint{ / } . 100 10000 -1 ext4 method{ format } format{ } use_filesystem{ } filesystem{ ext4 } mountpoint{ /home } .

# 3. MULTI: 1GB Boot, 15GB Swap, 15GB /, 15GB /usr, 10GB /var, Max /home
PART_MULTI := 1024 1024 1024 free \$$iflabel{ gpt } \$$reusemethod{ } method{ efi } format{ } . 15360 15360 15360 linux-swap method{ swap } format{ } . 15360 15360 15360 ext4 method{ format } format{ } use_filesystem{ } filesystem{ ext4 } mountpoint{ / } . 15360 15360 15360 ext4 method{ format } format{ } use_filesystem{ } filesystem{ ext4 } mountpoint{ /usr } . 10240 10240 10240 ext4 method{ format } format{ } use_filesystem{ } filesystem{ ext4 } mountpoint{ /var } . 100 10000 -1 ext4 method{ format } format{ } use_filesystem{ } filesystem{ ext4 } mountpoint{ /home } .

# Define the default fallback
TARGET_PART = $(PART_HOME)

# ==========================================
# Gaming Configuration Overrides
# ==========================================
PKG_GAMING   := plasma-desktop sddm nvidia-kernel-dkms nvidia-driver \
                intel-microcode thermald cpufrequtils gamemode flatpak unclutter

# ==========================================
# Target State Variables
# ==========================================
TARGET_PKGS   = $(BASE_PKGS)
TARGET_PART   = $(TARGET_PART)
TARGET_SCRIPT = $(SCRIPT_BASE)

# Simplified Late Command: just copy and execute the script natively.
LATE_CMD = cp /cdrom/setup.sh /target/root/setup.sh; in-target chmod +x /root/setup.sh; in-target /bin/bash /root/setup.sh

# ==========================================
# Dynamic CLI Overrides
# ==========================================
# Allow user to specify PART=auto, PART=home, or PART=multi at the command line.
ifeq ($(PART),auto)
    TARGET_PART = $(PART_AUTO)
else ifeq ($(PART),multi)
    TARGET_PART = $(PART_MULTI)
else
    # Default to HOME if no argument or an invalid argument is provided
    TARGET_PART = $(PART_HOME)
endif

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
	@cat << 'EOF' > setup.sh.tmp
$(TARGET_SCRIPT)
EOF
	@sed -e 's|@@WIFI_SSID@@|$(WIFI_SSID)|g' \
	     -e 's|@@WIFI_PASS@@|$(WIFI_PASS)|g' \
	     -e 's|@@ADMIN_PASS@@|$(ADMIN_PASS)|g' \
	     -e 's|@@GAMER_PASS@@|$(GAMER_PASS)|g' \
	     setup.sh.tmp > setup.sh
	@rm setup.sh.tmp
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