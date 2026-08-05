# Enable Cockpit socket
.PHONY: cocksock
cockcock:
	@echo "Enabling cockpit socket service ..."
	@systemctl enable cockpit.socket
