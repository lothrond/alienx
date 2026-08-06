# Set GRUB cmdline for NVIDIA
.PHONY: nvidia-grub

nvidia-grub:
	@echo "Setting GRUB cmdline for NVIDIA ..."
	@cp files/grub.nvidia /etc/default/grub
	@chmod 0644 /etc/default/grub
	@grub2-mkconfig -o /boot/grub/grub.cfg