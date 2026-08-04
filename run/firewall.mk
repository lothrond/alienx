# iptables firewall
.PHONY: firewall

firewall: firewall-script firewall-unit firewall-start

.PHONY: firewall-script firewall-unit firewall-start

firewall script:
	@echo "Installing firewall script ..."
	@cp files/iptables-firewall.sh /usr/local/bin/iptables-firewall.sh
	@chmod 0755 /usr/local/bin/iptables-firewall.sh

firewall-unit:
	@echo "Installing firewall systemd unit ..."
	@cp files/iptables-firewall.service /etc/systemd/system
	@chmod 0644 /etc/systemd/system/iptables-firewall.service

firewall-start:
	@echo "Enabling firewall service ..."
	@systemctl enable iptables-firewall.service
