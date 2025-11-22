#!/usr/bin/bash
# Source logging functions
source lib/logging.sh

log_start

# Instal melonDS
sudo flatpak install -y flathub net.kuribo64.melonDS

# Import Flatpak overrides
cp ./configs/flatpak/net.kuribo64.melonDS ${HOME}/.local/share/flatpak/overrides/net.kuribo64.melonDS

log_success "Module completed successfully"
log_end
