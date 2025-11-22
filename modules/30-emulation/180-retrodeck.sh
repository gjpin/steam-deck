#!/usr/bin/bash
# Source logging functions
source lib/logging.sh

log_start

# Instal RetroDeck
sudo flatpak install -y flathub net.retrodeck.retrodeck

# Import Flatpak overrides
cp ./configs/flatpak/net.retrodeck.retrodeck ${HOME}/.local/share/flatpak/overrides/net.retrodeck.retrodeck

log_success "Module completed successfully"
log_end
