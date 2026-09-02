# --- Debian - x86_64 - Alienware X51 R3 ---
# --- auto recovery image build system ---

# --- Define needed build packages ---
BUILD_PKGS :=
BUILD_PKGS += xorriso
BUILD_PKGS += cpio
BUILD_PKGS += isolinux
BUILD_PKGS += python3
BUILD_PKGS += whois
BUILD_PKGS += dvd+rw-tools

# Include ansible for development,
# not needed for building.
#BUILD_PKGS += ansible

# --- Define needed build system defaults ---
BUILD_DIR := ./work
BUILD_ASS := ./assets

# --- Define profile system ---
CONFIG := config

# --- Define base profile configuration settings ---
BUILD_CONFIG_BASE := $(CONFIG)/debian.mk
BUILD_CONFIG_BASE += $(CONFIG)/device.mk
BUILD_CONFIG_BASE += $(CONFIG)/base.mk
BUILD_CONFIG_BASE += $(CONFIG)/network.mk
BUILD_CONFIG_BASE += $(CONFIG)/packages.mk
BUILD_CONFIG_BASE += $(CONFIG)/users.mk
BUILD_CONFIG_BASE += $(CONFIG)/passwords.mk

# --- Define desktop profile configuration settings ---
BUILD_CONFIG_DESKTOP := $(BUILD_CONFIG_BASE)
BUILD_CONFIG_DESKTOP += $(CONFIG)/desktop.mk

# --- Define console profile configuration settings ---
BUILD_CONFIG_CONSOLE := $(BUILD_CONFIG_BASE)
BUILD_CONFIG_CONSOLE += $(CONFIG)/console.mk
BUILD_CONFIG_CONSOLE += $(CONFIG)/gaming.mk

# --- Define installation configuration settings ---
BUILD_CONFIG_INSTALL := $(CONFIG)/install.mk

# --- Resolve build target profile ---
include config.mk

# Needs packages.
PKGS := 

# Needs configured.
ifeq ($(PROFILE),base)
	include $(BUILD_CONFIG_BASE)
	PKGS += $(PKGS_BASE)
else ifeq ($(PROFILE),console)
	include $(BUILD_CONFIG_CONSOLE)
	PKGS += $(PKGS_CONSOLE)
else ifeq ($(PROFILE),desktop)
	include $(BUILD_CONFIG_DESKTOP)
	PKGS += $(PKGS_DESKTOP)
endif

# --- Resolve graphics ---
ifeq ($(GRAPHICS),amd)
	PKGS_GPU := $(PKGS_AMD) $(PKGS_AMD_ACCEL) $(PKGS_VULKAN)
	PKGS_GPU32 := $(PKGS_AMD32) $(PKGS_VULKAN32)
else ifeq ($(GRAPHICS),nvidia)
	PKGS_GPU := $(PKGS_NVIDIA) $(PKGS_NVIDIA_ACCEL) $(PKGS_VULKAN)
	PKGS_GPU32 := $(PKGS_NVIDIA32) $(PKGS_VULKAN32)
else ifeq ($(GRAPHICS),intel)
	PKGS_GPU := $(PKGS_INTEL) $(PKGS_INTEL_ACCEL)
	PKGS_GPU32 := $(PKGS_INTEL32)
else ifeq ($(GRAPHICS),none)
	PKGS_GPU := $(PKGS_NONE)
	PKGS_GPU32 := $(PKGS_NONE)
endif

# --- Resolve desktop environment ---
ifeq ($(DESKTOP), gnome)
	PKGS_DE := $(PKGS_GNOME)
else ifeq ($(DESKTOP),i3)
	PKGS_DE := $(PKGS_I3)
else ifeq ($(DESKTOP),plasma)
	PKGS_DE := $(PKGS_PLASMA)
else ifeq ($(DESKTOP),none)
	PKGS_DE := $(PKGS_NONE)
endif

# --- Resolve  web browser support ---
ifeq ($(BROWSER),firefox)
	PKGS_BROWSER := $(PKGS_BROWSER_FIREFOX)
else ifeq ($(BROWSER),chrome)
	PKGS_BROWSER := $(PKGS_BROWSER_CHROME)
else ifeq ($(BROWSER),elinks)
	PKGS_BROWSER := $(PKGS_BROWSER_ELINKS)
else ifeq ($(BROWSER),none)
	PKGS_BROWSER := $(PKGS_NONE)
endif

# --- Resolve office support ---
ifeq ($(OFFICE),true)
	PKGS_OFFICE := $(PKGS_OFFICE_LIBRE)
	PKGS_OFFICE += $(PKGS_OPT_LIBRE_GTK)
else ifeq ($(OFFICE),false)
	PKGS_OFFICE += $(PKGS_NONE)
endif

# --- Resolve bluray-dvd support ---
ifeq ($(BLURAY),true)
	PKGS_BLURAY := $(PKGS_MEDIA_BLURAY)
	PKGS_BLURAY += $(PKGS_MEDIA_VLC)
else ifeq ($(BLURAY),false)
	PKGS_BLURAY := $(PKGS_NONE)
endif

# --- Resolve advanced utilities ---
ifeq ($(ADVANCED),true)
	PKGS_ADVANCED := $(PKGS_ADVANCED)
else ifeq ($(),false)
	PKGS_ADVANCED := $(PKGS_NONE)
endif

# --- Resolve installation ---
include $(BUILD_CONFIG_INSTALL)

# --- Define overrides ---
include override.mk

# --- Define build ---
.PHONY: default download depends build clean info

default: build

## Optionally show information.
help:
	@echo "make -> Debian -> Alienware X51 R3 -> autoinst"
	@echo
	@echo "[USAGE]"
	@echo
	@echo "  make [PROFILE=OPTION] [BASE=OPTIONS]"
	@echo "  make [PROFILE=OPTION] [BASE=OPTIONS] [DESKTOP=OPTIONS]"
	@echo "  make [PROFILE=OPTION] [BASE=OPTIONS] [CONSOLE=OPTIONS]"
	@echo
	@echo "[BASE OPTIONS]"
	@echo
	@echo "  OUTPUT_ISO          =  Name the recovery ISO"
	@echo "  GRUB_ENTRY          =  Name the bootloader entry"
	@echo "  DEVICE:             =  /path/to/target/device"
	@echo "  PARTITION:          =  auto,multi,home,regular"
	@echo "  ADMIN_USER_NAME     =  Full geckos user name"
	@echo "  ADMIN_USER_LOGIN    =  Login username"
	@echo "  ADMIN_USER_PASS     =  **CHANGE THIS**"
	@echo "  LOCAL_HOST          =  Hostname"
	@echo "  LOCAL_LANG          =  System language (english US)"
	@echo "  LOCAL_KMAP          =  Keyboard keymap (english US)"
	@echo "  LOCAL_TZ            =  Timezone (UTC)"
	@echo "  COCKPIT_ENABLED     =  true,false"
	@echo "  COCKPIT_PORT        =  **CHANGE OPTIONAL**"
	@echo "  BROWSER             =  elinks,none"
	@echo
	@echo "[DESKTOP OPTIONS]"
	@echo
	@echo "  DESKTOP_USER_NAME   =  Full geckos user name"
	@echo "  DESKTOP_USER_LOGIN  =  Login username"
	@echo "  DESKTOP_USER_PASS   =  **CHANGE THIS**"
	@echo "  GRAPHICS            =  nvidia,amd,intel"
	@echo "  DESKTOP             =  gnome,plasma,i3"
	@echo "  SESSION             =  x11,wayland"
	@echo "  BROWSER             =  chrome,firefox"
	@echo "  BLURAY              =  false,true"
	@echo "  OFFICE              =  false,true"
	@echo
	@echo "[CONSOLE OPTIONS]"
	@echo
	@echo "  CONSOLE_USER_NAME   =  Full geckos user name"
	@echo "  CONSOLE_USER_LOGIN  =  Login username"
	@echo "  CONSOLE_USER_PASS   =  **CHANGE THIS**"
	@echo "  GRAPHICS            =  amd,intel,nvidia"
	@echo "  SESSION             =  x11,wayland"
	@echo "  PROTON_GE           =  false,true"
	@echo "  DECKY               =  false,true"
	@echo
	@echo "(See also the config/gaming.mk console settings.)"
	@echo
	@echo "[PROFILE OPTIONS]"
	@echo
	@echo "  PROFILE  = base,console,desktop"
	@echo
	@echo "   * base     Minimal base system"
	@echo "   * desktop  Full desktop system"
	@echo "   * console  Steam Big Picture console system"
	@echo
	@echo " **  Profile options can be set in config.mk."
	@echo " **  Profile configurations are stored in the config directory."
	@echo " **  User override configuration options can be set in override.mk."
	@echo " **  This includes an ansible playbook system."
	@echo " **  Ansible playbook assets are stored in the assets directory."
	@echo

## Needs a working directory.
$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

## Needs build dependency packages.
depends:
	@echo && echo " ---> Ensuring required build tools are installed ..."
	@sudo apt -y install $(BUILD_PKGS) >/dev/null 2>&1 || true

## Needs a working base Debian system.
download: $(BUILD_DIR)
	@if [ -f $(BUILD_DIR)/$(DEBIAN_ISO) ] || [ -f $(DEBIAN_ISO) ]; then \
		echo " ---> ISO already present -> skipping download."; \
	else \
		echo " ---> Downloading Debian netinst ISO ..."; \
	fi
	@if [ -f $(DEBIAN_ISO) ]; then \
		cp -v $(DEBIAN_ISO) $(BUILD_DIR) ; \
	else \
		curl -L -o $(BUILD_DIR)/$(DEBIAN_ISO) $(DEBIAN_ISO_URL) ; \
	fi

# --- build pipeline ---
.PHONY: msg extract inject repack verity end

## Start with a helpful display.
msg:
	@echo
	@echo " ---> Debian: $(DEBIAN_VERSION) $(DEBIAN_IMAGE) "
	@echo " ---> Profile: $(PROFILE) "
	@echo " ---> Output: $(OUTPUT_ISO) "
	@echo

## Extract a working base Debian system.
extract:
	@echo && echo " ---> Extracting ISO ..."
	@mkdir -p $(BUILD_DIR)/isofiles
	@xorriso -osirrox on -indev $(BUILD_DIR)/$(DEBIAN_ISO) -extract / $(BUILD_DIR)/isofiles
	@chmod -R +w $(BUILD_DIR)/isofiles

## Insert configuration changes.
inject:
	@echo && echo " ---> Injecting assets and substituting configuration ..."
	@rm -rf $(BUILD_DIR)/assets
	@cp -a $(BUILD_ASS) $(BUILD_DIR)/assets
	@mkdir -p $(BUILD_DIR)/assets/ansible/group_vars
	@find $(BUILD_DIR)/assets -type f \
        \( -name '*.template' -o -name '*.yml' -o -name '*.yaml' \
           -o -name '*.sh' -o -name '*.desktop' -o -name '*.conf' \
           -o -name '*.service' \) \
            -exec sed -i \
				-e "s|__DEVICE__|$(DEVICE)|g" \
				-e "s|__PARTITION__|$(PARTITION)|g" \
				-e "s|__NON_FREE__|$(NON_FREE)|g" \
				-e "s|__ADMIN_USER_NAME__|$(ADMIN_USER_NAME)|g" \
				-e "s|__ADMIN_USER_LOGIN__|$(ADMIN_USER_LOGIN)|g" \
				-e "s|__ADMIN_USER_PASSWORD|$(ADMIN_USER_PASSWORD)"
				-e "s|__CONSOLE_USER_NOME__|$(CONSOLE_USER_NAME)|g" \
				-e "s|__CONSOLE_USER_LOGIN__|$(CONSOLE_USER_LOGIN)|g" \
				-e "s|__DESKTOP_USER_NAME__|$(DESKTOP_USER_NAME)|g" \
				-e "s|__DESKTOP_USER_LOGIN__|$(DESKTOP_USER_LOGIN)|g" \
				-e "s|__WIFI_SSID__|$(WIFI_SSID)|g" \
				-e "s|__WIFI_PASS__|$(WIFI_PASS)|g" \
				-e "s|__BROWSER__|$(BROWSER)|g" \
				-e "s|__SESSION__|$(SESSION)|g" \
				-e "s|__GRAPHICS__|$(GRAPHICS)|g" \
				-e "s|__DESKTOP__|$(DESKTOP)|g" \
				-e "s|__OFFICE__|$(OFFICE)|g" \
				-e "s|__PROTON_GE__|$(PROTON_GE)|g" \
				-e "s|__DECKY__|$(DECKY)|g" \
				-e "s|__NATIVE_STEAM__|$(NATIVE_STEAM)|g" \
				-e "s|__COCKPIT_PORT__|$(COCKPIT_PORT)|g" \
				-e "s|__COCKPIT__|$(COCKPIT)|g" \
				-e "s|__FIREWALL__|$(FIREWALL__)|g" \
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
	@touch $(BUILD_DIR)/final_pkgs.txt
	@echo "$(PKGS)" > $(BUILD_DIR)/final_pkgs.txt
	PKGS_LIST=$$(tr '\n' ' ' < $(BUILD_DIR)/final_pkgs.txt)
	@sed -i "s|__PKGS__|$(PKGS)|g" $(BUILD_DIR)/assets/preseed.cfg.template
	@cp $(BUILD_DIR)/assets/preseed.cfg.template $(BUILD_DIR)/preseed.cfg
	@echo && echo " ---> Embedding preseed.cfg into initrd ..."
	@cd $(BUILD_DIR) && gunzip -f isofiles/install.amd/initrd.gz
	@cd $(BUILD_DIR) && echo preseed.cfg | cpio -H newc -o -A -F isofiles/install.amd/initrd
	@cd $(BUILD_DIR) && gzip isofiles/install.amd/initrd
	@echo && echo " ---> Adding automated install entry to GRUB ..."
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

## Repackage into abstracted Debian system.
repack:
	@echo && echo " ---> Repacking hybrid ISO ..."
	@xorriso -as mkisofs -o $(OUTPUT_ISO) \
		-isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
		-c isolinux/boot.cat -b isolinux/isolinux.bin \
		-no-emul-boot -boot-load-size 4 -boot-info-table \
		-eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot -isohybrid-gpt-basdat \
		$(BUILD_DIR)/isofiles

## Verify integrity.
verity:
	@echo && echo " ---> Recalculating checksums ..."
	@cd $(BUILD_DIR)/isofiles && md5sum $$(find -follow -type f) > md5sum.txt

## Handle success.
end:
	@echo
	@echo " ---> Good News Everyone."
	@echo " ---> ISO: $(OUTPUT_ISO)\n"

build: msg $(BUILD_DIR) download extract inject verity repack end

# --- Define ISO installation ---
.PHONY: install install-dvd

# --- ISO install pipeline ---
## Defaults to USB drive installation.
install: $(BUILD_CONFIG_INSTALL)
	@echo " ---> Installing to USB device: $(USB)"
	dd if=$(OUTPUT_ISO) of=$(USB) bs=$(BITESIZE) status=progress
	@echo && echo " ---> Done." && echo

## Install to a DVD (/CD).
install-dvd: $(BUILD_CONFIG_INSTALL)
	@echo " ---> Installing to DVD device: $(DVD)"
	@growisofs -dvd-compat -Z /dev/sr0=$(DVD)
	@echo && echo " ---> Done." && echo

# --- Define clean builds ---
.PHONY: cleanbuild

clean:
	@echo "Removing build ..."
	@rm -rf $(BUILD_DIR)
	@test $(OUTPUT_ISO) && rm -f $(OUTPUT_ISO)
	@echo "Done."

cleanbuild: clean build

