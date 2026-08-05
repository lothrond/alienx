# Allow passwordless sudo for console/gaming user
.PHONY: nopasswdsudo
nopasswdsudo:
	@echo "Allowing passwordless sudo for console user ..."
	@touch /etc/sudoers.d/$(USER_GAME)
	@echo -e "ALL=(ALL:ALL) NOPASSWD: ALL\n" > /etc/sudoers.d/$(USER_GAME)
	@chmod 0440 /etc/sudoers.d/$(USER_GAME)
	@visudo -cf %s
