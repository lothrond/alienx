# --- debian configuration settings ---

DEBIAN_VERSION ?= 13.6.0
DEBIAN_ARCH := amd64
DEBIAN_MIRROR := https://cdimage.debian.org
DEBIAN_IMAGE := netinst
## You probably don't want to change these settings.
DEBIAN_ISO := debian-$(DEBIAN_VERSION)-$(DEBIAN_ARCH)-$(DEBIAN_IMAGE).iso
DEBIAN_ISO_URL := $(DEBIAN_MIRROR)/debian-cd/current/$(DEBIAN_ARCH)/iso-cd/$(DEBIAN_ISO)

## Proprietary (non-free) software:
NON_FREE ?= true
