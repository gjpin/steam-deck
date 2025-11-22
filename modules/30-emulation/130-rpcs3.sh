#!/usr/bin/bash
# Source logging functions
source lib/logging.sh

log_start

# Instal RPCS3
sudo flatpak install -y flathub net.rpcs3.RPCS3

# Import Flatpak overrides
cp ./configs/flatpak/net.rpcs3.RPCS3 ${HOME}/.local/share/flatpak/overrides/net.rpcs3.RPCS3

log_success "Module completed successfully"
log_end
