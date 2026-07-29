# debian makefile configuration Variables
DEBIAN_VERSION   := 13.6.0
DEBIAN_ARCH      := amd64
ISO_NAME         := debian-$(DEBIAN_VERSION)-$(DEBIAN_ARCH)-netinst.iso
ISO_URL          := https://cdimage.debian.org/debian-cd/current/$(DEBIAN_ARCH)/iso-cd/$(ISO_NAME)

# Proprietary non-free software (true or false)
NON_FREE := true