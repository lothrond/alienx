# --- Debian x86_64 Alienware X51 R3 build system ---

# --- Define needed build packages ---
BUILD_PKGS :=
BUILD_PKGS += xorriso
BUILD_PKGS += cpio
BUILD_PKGS += isolinux
BUILD_PKGS += python3
#BUILD_PKGS += ansible

# --- Define needed build system defaults ---
BUILD_DIR ?= ./build
BUILD_ASS ?= ./assets
BUILD_RUN ?= ./run

# --- Define configuration system ---
CONFIG := config

include $(CONFIG)/debian.mk
include $(CONFIG)/device.mk
include $(CONFIG)/system.mk
include $(CONFIG)/desktop.mk
include $(CONFIG)/console.mk
include $(CONFIG)/packages.mk
include $(CONFIG)/network.mk

include config.mk

# --- Define needed build configuration settings ---

## System (shared)
BUILD_CONF_SYS :=
BUILD_CONF_SYS += $(CONFIG)/debian.mk
BUILD_CONF_SYS += $(CONFIG)/device.mk
BUILD_CONF_SYS += $(CONFIG)/system.mk
BUILD_CONF_SYS += $(CONFIG)/network.mk
BUILD_CONF_SYS += $(CONFIG)/packages.mk

## Default (Desktop)
BUILD_CONF_DEF := $(BUILD_CONF_SYS) $(CONFIG)/desktop.mk $(CONFIG)/nvidia.mk 

## Console
BUILD_CONF_CON := $(BUILD_CONF_SYS) $(CONFIG)/console.mk $(CONFIG)/nvidia.mk 

# --- Define build ---
.PHONY: all download deps build clean help

all: help

help:
	@echo "[USAGE:]"
	@echo
	@echo "  make [ENVIRONMENT] [OPTION]"
	@echo
	@echo "[OPTIONS:]"
	@echo
	@echo "  console  - make a desktop system"
	@echo "  desktop  - make a console-like system"
	@echo
	@echo "[ADDITIONAL OPTIONS:]"
	@echo
	@echo "  deps     - Install needed build depedencies"
	@echo "  download - Download a netinst ISO"
	@echo "  clean    - Remove build artifacts (for clean builds)"
	@echo "  help     - Show this message"
	@echo

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

download: $(BUILD_DIR)
	@if [ -f $(BUILD_DIR)/$(ISO_NAME) ]; then \
		echo "ISO already present, skipping download."; \
	else \
		echo "Downloading Debian Netinst ISO..."; \
		curl -L -o $(BUILD_DIR)/$(ISO_NAME) $(ISO_URL); \
	fi

deps:
	@echo "Ensuring required build tools are installed..."
	@sudo apt install -y $(BUILD_PKGS) > /dev/null 2>&1 || true

# --- Define build process ---
.PHONY: extract inject repack verity end

extract:
	@echo "Extracting ISO ..."
	@mkdir -p $(BUILD_DIR)/isofiles
	@xorriso -osirrox on -indev $(BUILD_DIR)/$(ISO_NAME) -extract / $(BUILD_DIR)/isofiles
	@chmod -R +w $(BUILD_DIR)/isofiles

inject:
	@echo "Injecting assets ..."
	@cp -r $(BUILD_ASS) $(BUILD_DIR)/assets
	@cp -r $(BUILD_RUN) $(BUILD_DIR)/run
	@cp -r $(CONFIG) $(BUILD_DIR)/config
	@cp Makefile config.mk $(BUILD_DIR)
	@echo "Injecting configuration variables ..."
	@find $(BUILD_DIR)/assets -type f \
	\( -name '*.template' -o -name '*.yml' -o -name '*.yaml' -o -name '*.sh' -o -name '*.desktop' -o -name '*.conf' \) \
	-exec sed -i \
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
		{} +
	@cp $(BUILD_DIR)/assets/preseed.cfg.template $(BUILD_DIR)/preseed.cfg
	@echo "Adding preseed.cfg to initrd..."
	@cd $(BUILD_DIR) && gunzip isofiles/install.amd/initrd.gz
	@cd $(BUILD_DIR) && echo preseed.cfg | cpio -H newc -o -A -F isofiles/install.amd/initrd
	@cd $(BUILD_DIR) && gzip isofiles/install.amd/initrd
	@echo "Injecting dedicated automated boot entries ..."
	@echo "Adding automated install entry to GRUB ..."
	@sed -i '1i\
	menuentry ">>> $(GRUB_ENTRY) <<<" {\
	set background_color=black\
	linux /install.amd/vmlinuz auto=true priority=critical preseed/file=/preseed.cfg\
	initrd /install.amd/initrd.gz\
    }\
    ' $(BUILD_DIR)/isofiles/boot/grub/grub.cfg
	@if [ -f $(BUILD_DIR)/isofiles/isolinux/txt.cfg ]; then \
		@echo "Adding automated install entry to isolinux ..."; \
		@sed -i '1i\
		label auto-install\
		menu label ^>>> $(GRUB_ENTRY) <<<\
		kernel /install.amd/vmlinuz\
		append auto=true priority=critical preseed/file=/preseed.cfg initrd=/install.amd/initrd.gz\
		' $(BUILD_DIR)/isofiles/isolinux/txt.cfg; \
		fi

repack:
	@echo "Repacking ..."
	@xorriso -as mkisofs -o $(OUTPUT_ISO) \
		-isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
		-c isolinux/boot.cat -b isolinux/isolinux.bin \
		-no-emul-boot -boot-load-size 4 -boot-info-table \
		-eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot -isohybrid-gpt-basdat \
		$(BUILD_DIR)/isofiles

verity:
	@echo "Recalculating checksums and building final bootable Debian ISO..."
	@cd $(BUILD_DIR)/isofiles && md5sum `find -follow -type f` > md5sum.txt

end:
	@echo -e "Build complete.\n\n ISO generated at: $(OUTPUT_ISO)"
<<<<<<< HEAD
    
build: $(BUILD_DIR) download extract inject verity repack end
    
=======

build: $(BUILD_DIR) download extract inject verity repack end

>>>>>>> restructure-playbook
# --- Define build targets ---
.PHONY: console desktop

desktop: $(BUILD_CONF_DEF) $(BUILD_ASS) build
console: $(BUILD_CONF_CON) $(BUILD_ASS) build

# --- Define clean builds ---
clean:
	@echo "Removing build artifacts..."
	@rm -rfv ./work
	@rm -rfv ./*.iso
	@echo "Done."
