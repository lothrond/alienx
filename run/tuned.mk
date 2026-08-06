# Enable and start tuned for system performance
.PHONY: tuned

tuned: tuned-service tuned-perf

.PHONY: tuned-service tuned-perf

## Systemd service
tuned-service:
	@echo "Enabling and starting the tuned systemd service ..."
	@systemctl start tuned
	@systemctl enable tuned

## Start tuned
tuned-perf:
	@echo "Starting tuned ..."
	@echo "Setting tuned profile to latency-performance ..."
	@tuned-adm profile latency-performance
