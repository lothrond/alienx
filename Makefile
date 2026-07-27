# --- Configuration Variables ---
DEBIAN_VERSION ?= 13.6.0
DEBIAN_ARCH    ?= amd64
ISO_NAME       ?= debian-$(DEBIAN_VERSION)-$(DEBIAN_ARCH)-netinst.iso
ISO_URL        ?= https://cdimage.debian.org/debian-cd/current/$(DEBIAN_ARCH)/iso-cd/$(ISO_NAME)

WORK_DIR       ?= ./work
OUTPUT_ISO     ?= ./custom-alienware-debian-trixie.iso

# --- Hardware & Software Variables ---
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

.PHONY: all clean download verify build

all: build

$(WORK_DIR):
	mkdir -p $(WORK_DIR)

download: $(WORK_DIR)
	@if [ -f $(WORK_DIR)/$(ISO_NAME) ]; then \
		echo "ISO already present, skipping download."; \
	else \
		echo "Downloading Debian Netinst ISO..."; \
		curl -L -o $(WORK_DIR)/$(ISO_NAME) $(ISO_URL); \
	fi

build: download
	@echo "Ensuring required build tools (xorriso, cpio) are installed..."
	@sudo apt-get install -y xorriso cpio isolinux > /dev/null 2>&1 || true

	@echo "Injecting variables into Preseed template..."
	sed \
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
		preseed.cfg.template > $(WORK_DIR)/preseed.cfg

	@echo "Extracting ISO and injecting preseed..."
	mkdir -p $(WORK_DIR)/isofiles
	xorriso -osirrox on -indev $(WORK_DIR)/$(ISO_NAME) -extract / $(WORK_DIR)/isofiles
	chmod -R +w $(WORK_DIR)/isofiles
	
	@echo "Adding preseed.cfg to initrd..."
	cd $(WORK_DIR) && gunzip isofiles/install.amd/initrd.gz
	cd $(WORK_DIR) && echo preseed.cfg | cpio -H newc -o -A -F isofiles/install.amd/initrd
	cd $(WORK_DIR) && gzip isofiles/install.amd/initrd
	cd $(WORK_DIR) && cd isofiles && md5sum `find -follow -type f` > md5sum.txt

	@echo "Building final bootable Debian ISO..."
	xorriso -as mkisofs -o $(OUTPUT_ISO) \
		-isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
		-c isolinux/boot.cat -b isolinux/isolinux.bin \
		-no-emul-boot -boot-load-size 4 -boot-info-table \
		-eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot -isohybrid-gpt-basdat \
		$(WORK_DIR)/isofiles
	@echo "Build complete! ISO generated at: $(OUTPUT_ISO)"

clean:
	./cleanup.sh