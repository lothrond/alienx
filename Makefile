# Makefile for Dynamic Debian Preseed & ISO Repacking
.ONESHELL:

# ==========================================
# Variables & Defaults (Overridden by wrappers)
# ==========================================
ISO_URL      := https://cdimage.debian.org/cdimage/weekly-builds/amd64/iso-cd/debian-testing-amd64-netinst.iso
ISO_FILE     := debian-netinst.iso
ISO_CUSTOM   := debian-custom-unattended.iso

CPU_VENDOR   ?= intel
GPU_VENDOR   ?= nvidia-maxwell
WIFI_SSID    ?= default_ssid
WIFI_PASS    ?= default_pass
ADMIN_PASS   ?= admin
GAMER_PASS   ?= gamer
COCKPIT_PORT ?= 9090

# ==========================================
# Partitioning Recipes (Sizes in MB)
# ==========================================
PART_AUTO  := 1024 1024 1024 free \$$iflabel{ gpt } \$$reusemethod{ } method{ efi } format{ } . 15360 15360 15360 linux-swap method{ swap } format{ } . 100 10000 -1 ext4 method{ format } format{ } use_filesystem{ } filesystem{ ext4 } mountpoint{ / } .
PART_HOME  := 1024 1024 1024 free \$$iflabel{ gpt } \$$reusemethod{ } method{ efi } format{ } . 15360 15360 15360 linux-swap method{ swap } format{ } . 15360 15360 15360 ext4 method{ format } format{ } use_filesystem{ } filesystem{ ext4 } mountpoint{ / } . 100 10000 -1 ext4 method{ format } format{ } use_filesystem{ } filesystem{ ext4 } mountpoint{ /home } .
PART_MULTI := 1024 1024 1024 free \$$iflabel{ gpt } \$$reusemethod{ } method{ efi } format{ } . 15360 15360 15360 linux-swap method{ swap } format{ } . 15360 15360 15360 ext4 method{ format } format{ } use_filesystem{ } filesystem{ ext4 } mountpoint{ / } . 15360 15360 15360 ext4 method{ format } format{ } use_filesystem{ } filesystem{ ext4 } mountpoint{ /usr } . 10240 10240 10240 ext4 method{ format } format{ } use_filesystem{ } filesystem{ ext4 } mountpoint{ /var } . 100 10000 -1 ext4 method{ format } format{ } use_filesystem{ } filesystem{ ext4 } mountpoint{ /home } .

ifeq ($(PART),auto)
    TARGET_PART = $(PART_AUTO)
else ifeq ($(PART),multi)
    TARGET_PART = $(PART_MULTI)
else
    TARGET_PART = $(PART_HOME)
endif

# ==========================================
# Hardware Profiling Logic
# ==========================================
ifeq ($(CPU_VENDOR),intel)
    PKG_CPU := intel-microcode thermald cpufrequtils
else ifeq ($(CPU_VENDOR),amd)
    PKG_CPU := amd64-microcode cpufrequtils
endif

ifeq ($(GPU_VENDOR),nvidia-maxwell)
    PKG_GPU := nvidia-driver nvidia-vulkan-icd nvidia-vulkan-icd:i386 libglx-nvidia0:i386 libvulkan1:i386
else ifeq ($(GPU_VENDOR),amd)
    PKG_GPU := firmware-amd-graphics mesa-vulkan-drivers mesa-vulkan-drivers:i386 libgl1-mesa-dri:i386
endif

# ==========================================
# Software Packages
# ==========================================
PKG_UTILS    := sudo efibootmgr vim nano wget curl git ufw apparmor apparmor-profiles cockpit
PKG_NET      := net-tools network-manager
PKG_BASE     := gnome-core gdm3
PKG_GAMING   := steam-installer steam-devices gamemode gamescope openbox sddm unclutter \
                libc6:i386 libgl1-mesa-dri:i386 libx11-6:i386 $(PKG_CPU) $(PKG_GPU)

# ==========================================
# Scripts
# ==========================================
define SCRIPT_BASE
#!/bin/bash
ufw --force enable
ufw allow @@COCKPIT_PORT@@/tcp

echo "admin:@@ADMIN_PASS@@" | chpasswd

mkdir -p /etc/systemd/system/cockpit.socket.d
cat << 'COCKPIT_EOF' > /etc/systemd/system/cockpit.socket.d/listen.conf
[Socket]
ListenStream=
ListenStream=@@COCKPIT_PORT@@
COCKPIT_EOF
endef

define SCRIPT_GAMING
#!/bin/bash
ufw --force enable
ufw allow @@COCKPIT_PORT@@/tcp

echo "admin:@@ADMIN_PASS@@" | chpasswd
useradd -m -G audio,video,netdev,input -s /bin/bash gamer
echo "gamer:@@GAMER_PASS@@" | chpasswd
passwd -d gamer

mkdir -p /etc/systemd/system/cockpit.socket.d
cat << 'COCKPIT_EOF' > /etc/systemd/system/cockpit.socket.d/listen.conf
[Socket]
ListenStream=
ListenStream=@@COCKPIT_PORT@@
COCKPIT_EOF

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

systemctl enable thermald || true
echo 'GOVERNOR="performance"' > /etc/default/cpufrequtils
systemctl restart cpufrequtils || true
echo 'ACTION=="add|change", KERNEL=="sd[a-z]|nvme[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"' > /etc/udev/rules.d/60-iosched.rules
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet"/GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=3 systemd.show_status=auto rd.udev.log_level=3 vt.global_cursor_default=0 mitigations=off nvidia-drm.modeset=1 pcie_aspm=force"/g' /etc/default/grub
update-grub

mkdir -p /usr/share/xsessions
cat << 'SESSION_EOF' > /usr/share/xsessions/steamos.desktop
[Desktop Entry]
Name=SteamOS
Comment=Standalone Steam Big Picture Session
Exec=/usr/local/bin/steamos-session.sh
Type=Application
SESSION_EOF

cat << 'STEAM_SCRIPT' > /usr/local/bin/steamos-session.sh
#!/bin/bash
export __GL_THREADED_OPTIMIZATIONS=1
export __GL_YIELD="USLEEP"
export __GL_SYNC_TO_VBLANK=0
export VDPAU_DRIVER="nvidia"

unclutter -idle 0.01 -root &
openbox &
exec gamescope -e -f -- steam -tenfoot
STEAM_SCRIPT
chmod +x /usr/local/bin/steamos-session.sh

mkdir -p /etc/sddm.conf.d
echo -e "[Autologin]\nUser=gamer\nSession=steamos" > /etc/sddm.conf.d/autologin.conf
endef

# ==========================================
# Target State Variables
# ==========================================
TARGET_MULTIARCH = 
TARGET_PKGS      = $(PKG_UTILS) $(PKG_NET) $(PKG_BASE)
TARGET_SCRIPT    = $(SCRIPT_BASE)
LATE_CMD         = cp /cdrom/setup.sh /target/root/setup.sh; in-target chmod +x /root/setup.sh; in-target /bin/bash /root/setup.sh

# ==========================================
# Make Targets
# ==========================================
.PHONY: all default gaming generate download repack clean

all: default

default: generate

gaming: TARGET_MULTIARCH := d-i apt-setup/multiarch string i386
gaming: TARGET_PKGS := $(PKG_UTILS) $(PKG_NET) $(PKG_GAMING)
gaming: TARGET_SCRIPT := $(SCRIPT_GAMING)
gaming: generate

generate:
	@echo "=> Injecting parameters into preseed.cfg..."
	@sed -e 's|@@PARTITION_RECIPE@@|$(TARGET_PART)|g' \
	     -e 's|@@PACKAGES@@|$(TARGET_PKGS)|g' \
	     -e 's|@@MULTIARCH_SETUP@@|$(TARGET_MULTIARCH)|g' \
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
	     -e 's|@@COCKPIT_PORT@@|$(COCKPIT_PORT)|g' \
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
	
	@echo "=> Injecting configuration..."
	@cp preseed.cfg isodir/preseed.cfg
	@cp setup.sh isodir/setup.sh
	@sed -i 's/append vga=788 initrd=\/install.amd\/initrd.gz/append vga=788 initrd=\/install.amd\/initrd.gz auto=true priority=critical preseed\/file=\/cdrom\/preseed.cfg/' isodir/isolinux/txt.cfg
	@sed -i 's/--- quiet/--- quiet auto=true priority=critical preseed\/file=\/cdrom\/preseed.cfg/' isodir/boot/grub/grub.cfg
	
	@echo "=> Repacking into $(ISO_CUSTOM)..."
	@xorriso -as mkisofs -r -V "DEBIAN_CUSTOM" -J -joliet-long -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot -isohybrid-gpt-basdat -isohybrid-apm-hfsplus -o $(ISO_CUSTOM) isodir
	@echo "=> Done! Burn $(ISO_CUSTOM) to your USB drive."

clean:
	rm -rf isodir preseed.cfg setup.sh setup.sh.tmp $(ISO_CUSTOM)