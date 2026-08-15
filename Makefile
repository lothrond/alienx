# ------------------------------------------------------------------ #
# --- Debian x86_64 Alienware X51 R3 recovery image build system --- #
# -------------------------------------------------------------------#

# WIP

# --- Define needed build packages ---
BUILD_PKGS :=
BUILD_PKGS += xorriso
BUILD_PKGS += cpio
BUILD_PKGS += isolinux
BUILD_PKGS += python3
BUILD_PKGS += whois
#BUILD_PKGS += ansible

# --- Define needed build system defaults ---
BUILD_DIR ?= ./build
BUILD_ASS ?= ./assets

# --- Define Profile ---
include config.mk

# --- Define build TARGET profile configuration settings ---

## Base system profile
BUILD_CONFIG_BASE := $(CONFIG)/debian.mk
BUILD_CONFIG_BASE += $(CONFIG)/device.mk
BUILD_CONFIG_BASE += $(CONFIG)/network.mk
BUILD_CONFIG_BASE += $(CONFIG)/packages.mk
BUILD_CONFIG_BASE += $(CONFIG)/system.mk
BUILD_CONFIG_BASE += $(CONFIG)/users.mk

## Desktop profile
BUILD_CONFIG_DESKTOP := $(BUILD_CONFIG_BASE)
BUILD_CONFIG_DESKTOP += $(CONFIG)/desktop.mk 

## Console profile
BUILD_CONFIG_CONSOLE := $(BUILD_CONFIG_BASE)
BUILD_CONFIG_CONSOLE += $(CONFIG)/console.mk

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
ifeq ($(BROWSER),firefox)
  PKGS_OPT += $(PKGS_BROWSER_FIREFOX)
else ifeq ($(BROWSER),chrome)
  PKGS_OPT += $(PKGS_BROWSER_CHROME)
else ifeq ($(BROWSER),elinks)
  PKGS_OPT += $(PKGS_BROWSER_ELINKS)
endif
ifeq ($(OFFICE),true)
  PKGS_OPT += $(PKGS_OFFICE)
endif

# --- Define build ---
.PHONY: all download deps build clean help

.PHONY: all help
all: help

help:
	@echo "[USAGE]  make <target> [VAR=value ...]"
	@echo
	@echo "[TARGETS]"
	@echo "  base      Minimal server / recovery"
	@echo "  desktop   Full desktop (DE selectable)"
	@echo "  console   Steam Big Picture console"
	@echo
	@echo "[GPU]     DRIVER_STACK=nvidia|amd|intel   (default nvidia/Maxwell)"
	@echo "[DE]      DESKTOP=plasma|gnome|i3|none    (desktop profile)"
	@echo "[SESSION] SESSION_TYPE=x11|wayland"
	@echo "[OTHER]   BROWSER=none|firefox|chrome|elinks"
	@echo "          OFFICE=true|false"
	@echo "          PROTON_GE=true|false  DECKY=true|false  (console)"
	@echo
	@echo "[PASSWORDS] prompted unless ADMIN_PASSWORD= / GAME_PASSWORD="
	@echo

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

deps:
	@echo "Ensuring required build tools are installed..."
	@sudo apt-get install -y $(BUILD_PKGS) >/dev/null 2>&1 || true

download: $(BUILD_DIR)
	@if [ -f $(BUILD_DIR)/$(ISO_NAME) ]; then \
		echo "ISO already present, skipping download."; \
	else \
		echo "Downloading Debian netinst ISO..."; \
		curl -L -o $(BUILD_DIR)/$(ISO_NAME) $(ISO_URL); \
	fi

# --- Passwords need hashed ---
define HASH_PW
	if command -v mkpasswd >/dev/null 2>&1; then \
		mkpasswd -m sha512crypt "$$plain"; \
	else \
		python3 -c "import crypt,sys; print(crypt.crypt(sys.argv[1], crypt.METHOD_SHA512))" "$$plain"; \
	fi
endef

define PROMPT_PW
	while true; do \
		printf "Enter %s: " "$(1)" > /dev/tty; \
		stty -echo < /dev/tty; read -r a < /dev/tty; stty echo < /dev/tty; printf "\n" > /dev/tty; \
		printf "Confirm %s: " "$(1)" > /dev/tty; \
		stty -echo < /dev/tty; read -r b < /dev/tty; stty echo < /dev/tty; printf "\n" > /dev/tty; \
		if [ -z "$$a" ]; then echo "Password cannot be empty." > /dev/tty; continue; fi; \
		if [ "$$a" = "$$b" ]; then plain="$$a"; break; fi; \
		echo "Passwords do not match. Try again." > /dev/tty; \
	done
endef

.PHONY: passwords-admin passwords-console

passwords-admin: $(BUILD_DIR)
	@echo "=== Administrator account password ==="
	@if [ -n "$(ADMIN_PASSWORD_HASH)" ]; then \
		hash="$(ADMIN_PASSWORD_HASH)"; echo "Using supplied ADMIN_PASSWORD_HASH."; \
	elif [ -n "$(ADMIN_PASSWORD)" ]; then \
		plain="$(ADMIN_PASSWORD)"; hash=$$($(HASH_PW)); echo "Hashed supplied ADMIN_PASSWORD."; \
	else \
		$(call PROMPT_PW,admin password); hash=$$($(HASH_PW)); \
	fi; \
	printf "export ADMIN_PASSWORD_HASH=%s\n" "$$hash" > $(BUILD_DIR)/passwords.env; \
	echo "Admin password hash ready."

passwords-console: $(BUILD_DIR)
	@echo "=== Administrator account password ==="
	@if [ -n "$(ADMIN_PASSWORD_HASH)" ]; then \
		ahash="$(ADMIN_PASSWORD_HASH)"; echo "Using supplied ADMIN_PASSWORD_HASH."; \
	elif [ -n "$(ADMIN_PASSWORD)" ]; then \
		plain="$(ADMIN_PASSWORD)"; ahash=$$($(HASH_PW)); echo "Hashed supplied ADMIN_PASSWORD."; \
	else \
		$(call PROMPT_PW,admin password); ahash=$$($(HASH_PW)); \
	fi; \
	echo "=== Console gamer account password ==="; \
	if [ -n "$(GAME_PASSWORD_HASH)" ]; then \
		ghash="$(GAME_PASSWORD_HASH)"; echo "Using supplied GAME_PASSWORD_HASH."; \
	elif [ -n "$(GAME_PASSWORD)" ]; then \
		plain="$(GAME_PASSWORD)"; ghash=$$($(HASH_PW)); echo "Hashed supplied GAME_PASSWORD."; \
	else \
		$(call PROMPT_PW,gamer password); ghash=$$($(HASH_PW)); \
	fi; \
	printf "export ADMIN_PASSWORD_HASH=%s\nexport GAME_PASSWORD_HASH=%s\n" \
		"$$ahash" "$$ghash" > $(BUILD_DIR)/passwords.env; \
	echo "Admin and gamer password hashes ready."

# --- ISO pipeline ---
.PHONY: extract inject repack verity end iso

extract:
	@echo "Extracting ISO..."
	@mkdir -p $(BUILD_DIR)/isofiles
	@xorriso -osirrox on -indev $(BUILD_DIR)/$(ISO_NAME) -extract / $(BUILD_DIR)/isofiles
	@chmod -R +w $(BUILD_DIR)/isofiles

inject:
	@echo "Injecting assets and substituting configuration..."
	@test -f $(BUILD_DIR)/passwords.env || \
		(echo "ERROR: $(BUILD_DIR)/passwords.env missing" >&2; exit 1)
	@set -a; . $(BUILD_DIR)/passwords.env; set +a; \
	rm -rf $(BUILD_DIR)/assets; \
	cp -a $(BUILD_ASS) $(BUILD_DIR)/assets; \
	mkdir -p $(BUILD_DIR)/assets/ansible/group_vars; \
	echo "$(PKGS)" > $(BUILD_DIR)/final_pkgs.txt; \
	GAME_HASH="$${GAME_PASSWORD_HASH:-}"; \
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
			{} +; \
	PKGS_LIST=$$(tr '\n' ' ' < $(BUILD_DIR)/final_pkgs.txt); \
	sed -i "s|__PKGS__|$$PKGS_LIST|g" $(BUILD_DIR)/assets/preseed.cfg.template; \
	cp $(BUILD_DIR)/assets/preseed.cfg.template $(BUILD_DIR)/preseed.cfg
	@echo "Embedding preseed.cfg into initrd..."
	@cd $(BUILD_DIR) && gunzip -f isofiles/install.amd/initrd.gz
	@cd $(BUILD_DIR) && echo preseed.cfg | cpio -H newc -o -A -F isofiles/install.amd/initrd
	@cd $(BUILD_DIR) && gzip isofiles/install.amd/initrd
	@echo "Adding automated install entry to GRUB..."
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
	@rm -f $(BUILD_DIR)/passwords.env
	@echo "Password hashes injected; temporary material removed."

repack:
	@echo "Repacking hybrid ISO..."
	@xorriso -as mkisofs -o $(OUTPUT_ISO) \
		-isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
		-c isolinux/boot.cat -b isolinux/isolinux.bin \
		-no-emul-boot -boot-load-size 4 -boot-info-table \
		-eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot -isohybrid-gpt-basdat \
		$(BUILD_DIR)/isofiles

verity:
	@echo "Recalculating checksums..."
	@cd $(BUILD_DIR)/isofiles && md5sum $$(find -follow -type f) > md5sum.txt

end:
	@echo -e "\nBuild complete.\n  ISO: $(OUTPUT_ISO)\n"

iso: $(BUILD_DIR) download extract inject verity repack end

# --- Profile pipeline ---
.PHONY: base desktop console

base: passwords-admin
	$(MAKE) iso \
		OUTPUT_ISO=./alienware-debian-base.iso \
		GRUB_ENTRY="ALIENWARE X51 R3 - BASE/SERVER - AUTOMATED RECOVERY (PRESEED)" \
		DRIVER_STACK="$(DRIVER_STACK)" SESSION_TYPE=x11 DESKTOP=none \
		BROWSER=none OFFICE=false PROTON_GE=false DECKY=false NATIVE_STEAM=false \
		PKGS="$(PKGS_BASE)"

desktop: passwords-admin
	$(MAKE) iso \
		OUTPUT_ISO=./alienware-debian-desktop.iso \
		GRUB_ENTRY="ALIENWARE X51 R3 - DESKTOP - AUTOMATED RECOVERY (PRESEED)" \
		DRIVER_STACK="$(DRIVER_STACK)" SESSION_TYPE="$(SESSION_TYPE)" \
		DESKTOP="$(DESKTOP)" BROWSER="$(BROWSER)" OFFICE="$(OFFICE)" \
		PROTON_GE=false DECKY=false NATIVE_STEAM=false \
		PKGS="$(PKGS_FOR_DESKTOP)"

console: passwords-console
	$(MAKE) iso \
		OUTPUT_ISO=./alienware-debian-console.iso \
		GRUB_ENTRY="ALIENWARE X51 R3 - CONSOLE - AUTOMATED RECOVERY (PRESEED)" \
		DRIVER_STACK="$(DRIVER_STACK)" SESSION_TYPE=x11 \
		DESKTOP=none BROWSER="$(BROWSER)" OFFICE=false \
		PROTON_GE="$(PROTON_GE)" DECKY="$(DECKY)" NATIVE_STEAM=true \
		PKGS="$(PKGS_FOR_CONSOLE)"

# --- Clean builds ---
.PHONY: clean
clean:
	@echo "Removing build artefacts..."
	@rm -rf $(BUILD_DIR) ./build ./*.iso
	@echo "Done."
