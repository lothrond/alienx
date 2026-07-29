include hardware.mk
include debian.mk
include system.mk
include desktop.mk
include console.mk
include packages.mk

# --- Define defaults
WORK_DIR         ?= ./work
OUTPUT_ISO       ?= ./custom-alienware-debian-trixie.iso

# --- Define default system ---
WIFI_SSID        ?= MyHomeNetwork
WIFI_PASS        ?= SuperSecretPassword
ROOT_PASSWORD    ?= rootpassword123
USER_PASSWORD    ?= userpassword123
BROWSER          ?= firefox
DRIVER_STACK     ?= nouveau
SESSION_TYPE     ?= wayland
BLURAY_SUPPORT   ?= false
NATIVE_STEAM     ?= false
COCKPIT_PORT     ?= 9090
FIREWALL_ENABLED ?= true


.PHONY: all download verify build help desktop console clean

all: help

$(WORK_DIR):
	mkdir -p $(WORK_DIR)

help:
	@echo "[USAGE:]"
	@echo
	@echo "  make [ENVIRONMENT] [OPTION]"
	@echo
	@echo "[OPTIONS:]"
	@echo
	@echo "  console - Target a desktop build environment"
	@echo "  desktop - Target a console-like envronmant"
	@echo "  clean   - Remove build artifacts"
	@echo "  help    - Show this message"
	@echo

download: $(WORK_DIR)
	@if [ -f $(WORK_DIR)/$(ISO_NAME) ]; then \
		echo "ISO already present, skipping download."; \
	else \
		echo "Downloading Debian Netinst ISO..."; \
		curl -L -o $(WORK_DIR)/$(ISO_NAME) $(ISO_URL); \
	fi

build: download hardware.mk debian.mk system.mk users.mk packages.mk 
	@echo "Ensuring required build tools (xorriso, cpio, python3) are installed..."
	@sudo apt-get install -y xorriso cpio isolinux python3 > /dev/null 2>&1 || true

	@echo "Injecting variables into Preseed template..."
	@sed \
		-e 's|__DEVICE__|$(DEVICE)|g' \
		-e 's|__PARTS__|$(PARTS)|g' \
		-e 's|__NON_FREE__|$(NON_FREE)|g' \
		-e 's|__USER_ADMIN__|$(USER_ADMIN)|g' \
		-e 's|__USER_GAMER__|$(USER_GAMER)|g' \
		-e 's|__USER_ADMIN_FULL__|$(USER_ADMIN_FULL)|g' \
		-e 's|__USER_GAMER_FULL__|$(USER_GAMER_FULL)|g' \
		-e 's|__ROOT_PASSWORD__|$(ROOT_PASSWORD)|g' \
		-e 's|__USER_PASSWORD__|$(USER_PASSWORD)|g' \
		-e 's|__WIFI_SSID__|$(WIFI_SSID)|g' \
		-e 's|__WIFI_PASS__|$(WIFI_PASS)|g' \
		-e 's|__BROWSER__|$(BROWSER)|g' \
		-e 's|__DRIVER_STACK__|$(DRIVER_STACK)|g' \
		-e 's|__SESSION_TYPE__|$(SESSION_TYPE)|g' \
		-e 's|__BLURAY_SUPPORT__|$(BLURAY_SUPPORT)|g' \
		-e 's|__NATIVE_STEAM__|$(NATIVE_STEAM)|g' \
		-e 's|__COCKPIT_PORT__|$(COCKPIT_PORT)|g' \
		-e 's|__FIREWALL_ENABLED__|$(FIREWALL_ENABLED)|g' \
		-e 's|__LOCAL_HOST__|$(LOCAL_HOST)|g' \
		-e 's|__LOCAL_LANG__|$(LOCAL_LANG)|g' \
		-e 's|__LOCAL_KMAP__|$(LOCAL_KMAP)|g' \
		-e 's|__LOCAL_TZ__|$(LOCAL_TZ)|g' \
		-e 's|__PKG__|$(PKG)|g' \
		preseed.cfg.template > $(WORK_DIR)/preseed.cfg

	@echo "Extracting ISO and injecting preseed..."
	@mkdir -p $(WORK_DIR)/isofiles
	@xorriso -osirrox on -indev $(WORK_DIR)/$(ISO_NAME) -extract / $(WORK_DIR)/isofiles
	@chmod -R +w $(WORK_DIR)/isofiles
	
	@echo "Adding preseed.cfg to initrd..."
	@cd $(WORK_DIR) && gunzip isofiles/install.amd/initrd.gz
	@cd $(WORK_DIR) && echo preseed.cfg | cpio -H newc -o -A -F isofiles/install.amd/initrd
	@cd $(WORK_DIR) && gzip isofiles/install.amd/initrd

	@echo "Injecting dedicated automated boot entries..."
	# Inject into UEFI GRUB menu
	@python3 -c ' \
	path = "$(WORK_DIR)/isofiles/boot/grub/grub.cfg"; \
	with open(path, "r") as f: content = f.read(); \
	custom_entry = "menuentry \">>> AUTOMATED ALIENWARE X51 R3 INSTALL (Preseed) <<<\" {\n" \
	"	set background_color=black\n" \
	"	linux /install.amd/vmlinuz auto=true priority=critical preseed/file=/preseed.cfg quiet splash loglevel=3 rd.udev.log_level=3 vt.global_cursor_default=0 mitigations=off\n" \
	"	initrd /install.amd/initrd.gz\n" \
	"}\n"; \
	with open(path, "w") as f: f.write(custom_entry + content); \
	' || true

	# Inject into BIOS Isolinux txt.cfg menu if present
	@if [ -f $(WORK_DIR)/isofiles/isolinux/txt.cfg ]; then \
		python3 -c ' \
		path = "$(WORK_DIR)/isofiles/isolinux/txt.cfg"; \
		with open(path, "r") as f: content = f.read(); \
		custom_txt = "label auto-install\n" \
		"	menu label ^>>> AUTOMATED ALIENWARE X51 R3 INSTALL (Preseed) <<<\n" \
		"	kernel /install.amd/vmlinuz\n" \
		"	append auto=true priority=critical preseed/file=/preseed.cfg initrd=/install.amd/initrd.gz quiet splash loglevel=3 rd.udev.log_level=3 vt.global_cursor_default=0 mitigations=off\n"; \
		with open(path, "w") as f: f.write(custom_txt + content); \
		' || true; \
	fi

	@echo "Recalculating checksums and building final bootable Debian ISO..."
	cd $(WORK_DIR)/isofiles && md5sum `find -follow -type f` > md5sum.txt
	xorriso -as mkisofs -o $(OUTPUT_ISO) \
		-isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
		-c isolinux/boot.cat -b isolinux/isolinux.bin \
		-no-emul-boot -boot-load-size 4 -boot-info-table \
		-eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot -isohybrid-gpt-basdat \
		$(WORK_DIR)/isofiles
	@echo "Build complete! ISO generated at: $(OUTPUT_ISO)"

console: console.mk build

desktop: desktop.mk build

clean:
	@echo "Removing build artifacts..."
	@rm -rfv ./work
	@rm -rfv ./*.iso
	@echo "Done."
