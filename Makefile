# --- Debian - x86_64 - Alienware X51 R3 ---
# --- auto recovery image build system ---

# --- Define needed build packages ---
BUILD_PKGS :=
BUILD_PKGS += xorriso
BUILD_PKGS += cpio
BUILD_PKGS += isolinux
BUILD_PKGS += python3
BUILD_PKGS += whois
#BUILD_PKGS += ansible

# --- Define needed build system defaults ---
BUILD_DIR ?= ./work
BUILD_ASS ?= ./assets

# --- Define profiles
CONFIG := config
include config.mk

# --- Define user overrides
include override.mk

# --- Define profile configuration settings ---

## Base system profile
BUILD_CONFIG_BASE := $(CONFIG)/base.mk
BUILD_CONFIG_BASE += $(CONFIG)/debian.mk
BUILD_CONFIG_BASE += $(CONFIG)/device.mk
BUILD_CONFIG_BASE += $(CONFIG)/network.mk
BUILD_CONFIG_BASE += $(CONFIG)/packages.mk
BUILD_CONFIG_BASE += $(CONFIG)/system.mk
BUILD_CONFIG_BASE += $(CONFIG)/users.mk
BUILD_CONFIG_BASE += $(CONFIG)/passwords.mk

## Desktop profile
BUILD_CONFIG_DESKTOP := $(BUILD_CONFIG_BASE)
BUILD_CONFIG_DESKTOP += $(CONFIG)/desktop.mk

## Console profile
BUILD_CONFIG_CONSOLE := $(BUILD_CONFIG_BASE)
BUILD_CONFIG_CONSOLE += $(CONFIG)/console.mk
BUILD_CONFIG_CONSOLE += $(CONFIG)/gaming.mk # For now

## Resolve build TARGET
ifeq ($(TARGET), base)
	include $(BUILD_CONFIG_BASE)
else ifeq ($(TARGET), console)
	include $(BUILD_CONFIG_CONSOLE)
else ifeq ($(TARGET), desktop)
	include $(BUILD_CONFIG_DESKTOP)
else
	echo "Invalid TARGET in config.mk"
	exit 1
endif

# --- Resolve graphics ---
ifeq ($(DRIVER_STACK), amd)
  PKGS_GPU := $(PKGS_AMD) $(PKGS_AMD_ACCEL)
  PKGS_GPU32 := $(PKGS_AMD32)
else ifeq ($(DRIVER_STACK), nvidia)
  PKGS_GPU := $(PKGS_NVIDIA) $(PKGS_NVIDIA_ACCEL)
  PKGS_GPU32 := $(PKGS_NVIDIA32)
else
  # Defaults to on-board intel graphics
  PKGS_GPU := $(PKGS_INTEL) $(PKGS_INTEL_ACCEL)
  PKGS_GPU32 := $(PKGS_INTEL32)
endif

# --- Resolve desktop ---
ifeq ($(DESKTOP),gnome)
  PKGS_DE_SEL := $(PKGS_GNOME) $(PKGS_DM_GNOME)
else ifeq ($(DESKTOP),i3)
  PKGS_DE_SEL := $(PKGS_I3) $(PKGS_DM_I3)
else ifeq ($(DESKTOP),plasma)
  PKGS_DE_SEL := $(PKGS_PLASMA) $(PKGS_DM_PLASMA)
else
  PKGS_DE_SEL :=
endif

# --- Resolve desktop application support ---
PKGS_OPT :=

# WWW Browser
ifeq ($(BROWSER),firefox)
	PKGS_OPT += $(PKGS_BROWSER_FIREFOX)
else ifeq ($(BROWSER),chrome)
	PKGS_OPT += $(PKGS_BROWSER_CHROME)
else ifeq ($(BROWSER),elinks)
	PKGS_OPT += $(PKGS_BROWSER_ELINKS)
else ifeq ($(BROWSER),none)
	# none
else
	@echo "Invalid browser ($BROWSER) selection."
	exit 1
endif

# Office
ifeq ($(OFFICE),true)
	PKGS_OPT += $(PKGS_OFFICE)
endif

# --- Define build ---
.PHONY: default download depends build clean help

default: build

# Strip? Or maybe keep.
help:
	@echo "[USAGE]"
	@echo
	@echo "  make [PROFILE=OPTION] [BASE=OPTIONS]"
	@echo "  make [PROFILE=OPTION] [BASE=OPTIONS] [DESKTOP=OPTIONS]"
	@echo "  make [PROFILE=OPTION] [BASE=OPTIONS] [CONSOLE=OPTIONS]"
	@echo
	@echo "[BASE OPTIONS]"
	@echo
	@echo "  ADMIN_USER_NAME     =  Full geckos user name"
	@echo "  ADMIN_USER_LOGIN    =  login username"
	@echo "  ADMIN_USER_PASS     =  **CHANGE THIS**"
	@echo "  FIXTHISASSSSSSSS"
	@echo
	@echo "[DESKTOP OPTIONS]"
	@echo
	@echo "  DESKTOP_USER_NAME   =  Full geckos user name"
	@echo "  DESKTOP_USER_LOGIN  =  login name"
	@echo "  DESTOP_USER_PASS    =  **CHANGE THIS**"
	@echo "  DRIVER_STACK        =  nvidia,amd,intel"
	@echo "  DESKTOP             =  plasma,gnome,i3,none"
	@echo "  SESSION_TYPE        =  x11,wayland"
	@echo "  BROWSER             =  none,firefox,chrome,elinks"
	@echo "  OFFICE              =  true,false"
	@echo
	@echo "[CONSOLE OPTIONS]"
	@echo
	@echo "  CONSOLE_USER_NAME   =  Full geckos user name"
	@echo "  CONSOLE_USER_LOGIN  =  login username"
	@echo "  CONSOLE_USER_PASS   =  **CHANGE THIS**"
	@echo "  DRIVER_STACK        =  nvidia,amd,intel"
	@echo "  SESSION_TYPE        =  x11,wayland"
	@echo "  PROTON_GE           =  true,false"
	@echo "  DECKY               =  true,false"
	@echo
	@echo "[PROFILE OPTIONS]"
	@echo
	@echo "  TARGET = base,console,desktop"
	@echo
	@echo "   * base     Minimal base system"
	@echo "   * desktop  Full desktop system"
	@echo "   * console  Steam Big Picture console system"
	@echo
	@echo " ** Profile TARGET options can be set in config.mk."
	@echo " ** Profile configurations are stored in the config directory."
	@echo " ** User override configuration options can be set in override.mk."
	@echo " ** This includes an ansible playbook system."
	@echo " ** Ansible playbook assets are stored in the assets directory."
	@echo
	@echo "Copyright (C) 2026, Michael S. Moss"

$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

depends:
	@echo "Ensuring required build tools are installed ..."
	@sudo apt -y install $(BUILD_PKGS) >/dev/null 2>&1 || true

download: $(BUILD_DIR)
	@if [ -f $(BUILD_DIR)/$(DEBIAN_ISO) ] || [ -f $(DEBIAN_ISO) ]; then \
		echo " ---> ISO already present -> skipping download."; \
	else \
		echo " ---> Working base Debian netinst ISO ..."; \
	fi
	@if [ -f $(DEBIAN_ISO) ]; then \
		cp -v $(DEBIAN_ISO) $(BUILD_DIR); \
	else \
		curl -L -o $(BUILD_DIR)/$(DEBIAN_ISO) $(DEBIAN_ISO_URL); \
	fi

# --- build pipeline ---
.PHONY: info extract inject repack verity msg

info:
	@echo
	@echo " ---> Debian: $(DEBIAN_VERSION) $(DEBIAN_IMAGE) "
	@echo " ---> Profile: $(TARGET) "
	@echo " ---> Output: $(OUTPUT_ISO) "
	@echo

extract:
	@echo " ---> Extracting ISO ..."
	@mkdir -p $(BUILD_DIR)/isofiles
	@xorriso -osirrox on -indev $(BUILD_DIR)/$(DEBIAN_ISO) -extract / $(BUILD_DIR)/isofiles
	@chmod -R +w $(BUILD_DIR)/isofiles

inject:
	@echo " ---> Injecting assets and substituting configuration ..."
	rm -rf $(BUILD_DIR)/assets; \
	cp -a $(BUILD_ASS) $(BUILD_DIR)/assets; \
	mkdir -p $(BUILD_DIR)/assets/ansible/group_vars; \
	echo "$(PKGS)" > $(BUILD_DIR)/final_pkgs.txt; \
	find $(BUILD_DIR)/assets -type f \
		\( -name '*.template' -o -name '*.yml' -o -name '*.yaml' \
		   -o -name '*.sh' -o -name '*.desktop' -o -name '*.conf' \
		   -o -name '*.service' \) \
			-exec sed -i \
			-e "s|__DEVICE__|$(DEVICE)|g" \
			-e "s|__PARTS__|$(PARTS)|g" \
			-e "s|__NON_FREE__|$(NON_FREE)|g" \
			-e "s|__USER_ADMIN__|$(USER_ADMIN)|g" \
			-e "s|__USER_ADMIN_FULL__|$(USER_ADMIN_FULL)|g" \
			-e "s|__USER_GAME__|$(USER_GAME)|g" \
			-e "s|__USER_GAME_FULL__|$(USER_GAME_FULL)|g" \
			-e "s|__ADMIN_PASSWORD_HASH__|$$ADMIN_PASSWORD_HASH|g" \
			-e "s|__GAME_PASSWORD_HASH__|$$GAME_HASH|g" \
			-e "s|__WIFI_SSID__|$(WIFI_SSID)|g" \
			-e "s|__WIFI_PASS__|$(WIFI_PASS)|g" \
			-e "s|__BROWSER__|$(BROWSER)|g" \
			-e "s|__SESSION_TYPE__|$(SESSION_TYPE)|g" \
			-e "s|__DRIVER_STACK__|$(DRIVER_STACK)|g" \
			-e "s|__DESKTOP__|$(DESKTOP)|g" \
			-e "s|__OFFICE__|$(OFFICE)|g" \
			-e "s|__PROTON_GE__|$(PROTON_GE)|g" \
			-e "s|__DECKY__|$(DECKY)|g" \
			-e "s|__NATIVE_STEAM__|$(NATIVE_STEAM)|g" \
			-e "s|__COCKPIT_PORT__|$(COCKPIT_PORT)|g" \
			-e "s|__COCKPIT_ENABLED__|$(COCKPIT_ENABLED)|g" \
			-e "s|__FIREWALL_ENABLED__|$(FIREWALL_ENABLED)|g" \
			-e "s|__LOCAL_HOST__|$(LOCAL_HOST)|g" \
			-e "s|__LOCAL_LANG__|$(LOCAL_LANG)|g" \
			-e "s|__LOCAL_KMAP__|$(LOCAL_KMAP)|g" \
			-e "s|__LOCAL_TZ__|$(LOCAL_TZ)|g" \
			-e "s|__GAMING_CPU_GOVERNOR_PERFORMANCE__|$(GAMING_CPU_GOVERNOR_PERFORMANCE)|g" \
			-e "s|__GAMING_IRQBALANCE_ENABLED__|$(GAMING_IRQBALANCE_ENABLED)|g" \
			-e "s|__GAMING_GAMEMODE_ENABLED__|$(GAMING_GAMEMODE_ENABLED)|g" \
			-e "s|__GAMING_GAMEMODE_IOPRIO__|$(GAMING_GAMEMODE_IOPRIO)|g" \
			-e "s|__GAMING_GAMEMODE_RENICE__|$(GAMING_GAMEMODE_RENICE)|g" \
			-e "s|__GAMING_GAMEMODE_SOFTREALTIME__|$(GAMING_GAMEMODE_SOFTREALTIME)|g" \
			-e "s|__GAMING_GAMEMODE_INHIBIT_SCREENSAVER__|$(GAMING_GAMEMODE_INHIBIT_SCREENSAVER)|g" \
			-e "s|__GAMING_NVIDIA_POWERMIZER_MAX_PERF__|$(GAMING_NVIDIA_POWERMIZER_MAX_PERF)|g" \
			-e "s|__GAMING_NVIDIA_ENABLE_MSI__|$(GAMING_NVIDIA_ENABLE_MSI)|g" \
			-e "s|__GAMING_NVIDIA_XORG_TUNING__|$(GAMING_NVIDIA_XORG_TUNING)|g" \
			-e "s|__GAMING_NVIDIA_COOLBITS__|$(GAMING_NVIDIA_COOLBITS)|g" \
			-e "s|__GAMING_SYSCTL_TUNING__|$(GAMING_SYSCTL_TUNING)|g" \
			-e "s|__GAMING_SYSCTL_VM_MAX_MAP_COUNT__|$(GAMING_SYSCTL_VM_MAX_MAP_COUNT)|g" \
			-e "s|__GAMING_SYSCTL_VM_SWAPPINESS__|$(GAMING_SYSCTL_VM_SWAPPINESS)|g" \
			-e "s|__GAMING_IO_SCHEDULER_TUNING__|$(GAMING_IO_SCHEDULER_TUNING)|g" \
			-e "s|__GAMING_IO_SCHEDULER_NVME__|$(GAMING_IO_SCHEDULER_NVME)|g" \
			-e "s|__GAMING_IO_SCHEDULER_SSD__|$(GAMING_IO_SCHEDULER_SSD)|g" \
			-e "s|__GAMING_IO_SCHEDULER_HDD__|$(GAMING_IO_SCHEDULER_HDD)|g" \
			-e "s|__GAMING_MANGOHUD_ENABLED__|$(GAMING_MANGOHUD_ENABLED)|g" \
			{} +; \
	PKGS_LIST=$$(tr '\n' ' ' < $(BUILD_DIR)/final_pkgs.txt); \
	sed -i "s|__PKGS__|$$PKGS_LIST|g" $(BUILD_DIR)/assets/preseed.cfg.template; \
	cp $(BUILD_DIR)/assets/preseed.cfg.template $(BUILD_DIR)/preseed.cfg
	@echo " ---> Embedding preseed.cfg into initrd ..."
	@cd $(BUILD_DIR) && gunzip -f isofiles/install.amd/initrd.gz
	@cd $(BUILD_DIR) && echo preseed.cfg | cpio -H newc -o -A -F isofiles/install.amd/initrd
	@cd $(BUILD_DIR) && gzip isofiles/install.amd/initrd
	@echo " ---> Adding automated install entry to GRUB ..."
	@sed -i '1i\
	menuentry ">>> $(GRUB_ENTRY) <<<" {\
	set background_color=black\
	linux /install.amd/vmlinuz auto=true priority=critical preseed/file=/preseed.cfg\
	initrd /install.amd/initrd.gz\
	}\
	' $(BUILD_DIR)/isofiles/boot/grub/grub.cfg
	@if [ -f $(BUILD_DIR)/isofiles/isolinux/txt.cfg ]; then \
		sed -i '1i\
		label auto-install\
	menu label ^>>> $(GRUB_ENTRY) <<<\
	kernel /install.amd/vmlinuz\
	append auto=true priority=critical preseed/file=/preseed.cfg initrd=/install.amd/initrd.gz\
	' $(BUILD_DIR)/isofiles/isolinux/txt.cfg; \
	fi

repack:
	@echo "\n ---> Repacking hybrid ISO ..."
	@xorriso -as mkisofs -o $(OUTPUT_ISO) \
		-isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
		-c isolinux/boot.cat -b isolinux/isolinux.bin \
		-no-emul-boot -boot-load-size 4 -boot-info-table \
		-eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot -isohybrid-gpt-basdat \
		$(BUILD_DIR)/isofiles

verity:
	@echo "\n ---> Recalculating checksums ..."
	@cd $(BUILD_DIR)/isofiles && md5sum $$(find -follow -type f) > md5sum.txt

msg:
	@echo "\n ---> Good News Everyone."
	@echo " ---> ISO: $(OUTPUT_ISO)\n"

build: info $(BUILD_DIR) download extract inject verity repack msg

# --- Clean builds ---
.PHONY: clean cleanbuild
clean:
	@echo "Removing build ..."
	@rm -rf $(BUILD_DIR)
	@test $(OUTPUT_ISO) && rm -rf $(OUPUT_ISO)
	@echo "Done."

cleanbuild: clean build
