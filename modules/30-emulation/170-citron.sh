#!/usr/bin/bash
# Source logging functions
source lib/logging.sh

log_start

# Instal Citron
sudo flatpak install -y private org.citronemu.Citron

# Import Flatpak overrides
cp ./configs/flatpak/org.citronemu.Citron ${HOME}/.local/share/flatpak/overrides/org.citronemu.Citron

log_success "Module completed successfully"
log_end
