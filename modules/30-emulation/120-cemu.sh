#!/usr/bin/bash
# Source logging functions
source lib/logging.sh

log_start

# Instal CEMU
sudo flatpak install -y flathub info.cemu.Cemu

# Import Flatpak overrides
cp ./configs/flatpak/info.cemu.Cemu ${HOME}/.local/share/flatpak/overrides/info.cemu.Cemu

log_success "Module completed successfully"
log_end
