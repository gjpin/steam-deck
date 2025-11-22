#!/usr/bin/bash
# Source logging functions
source lib/logging.sh

log_start

# Install ProtonPlus
flatpak install -y flathub com.vysp3r.ProtonPlus

# Import Flatpak overrides
cp ./configs/flatpak/com.vysp3r.ProtonPlus ${HOME}/.local/share/flatpak/overrides/com.vysp3r.ProtonPlus

log_success "Module completed successfully"
log_end
