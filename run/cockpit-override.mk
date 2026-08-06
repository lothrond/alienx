# Override Cockpit listen port
.PHONY: cockpit-override

cockpit-override: cockpit-dropin override-config cockpit-reload

.PHONY: cockpit-dropin override-config cockpit-reload

cockpit-dropin:
	@echo "Creating cockpit.socket drop-in directory ..."
	@mkdir -p /etc/systemd/system/cockpit.socket.d
	@chmod 0755 /etc/systemd/system/cockpit.sockit.d

override-config:
	@echo "Writing cockpit port override ..."
	@touch /etc/systemd/system/cockpit.sockit.d/override.conf
	@echo "[Socket]" > /etc/systemd/system/cockpit.sockit.d/override.conf
	@echo "ListenStream=" >> /etc/systemd/system/cockpit.sockit.d/override.conf
	@echo "ListenStream=$(COCKPIT_PORT)" >> /etc/systemd/system/cockpit.sockit.d/override.conf
	@chmod 0644 /etc/systemd/system/cockpit.sockit.d/override.conf

cockpit-reload:
	@echo "Reload systemd after cockpit override ..."
	@systemctl daemon-reload
