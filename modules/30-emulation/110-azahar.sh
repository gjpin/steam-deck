#!/usr/bin/bash
# Source logging functions
source lib/logging.sh

log_start

# Instal Azahar
sudo flatpak install -y flathub org.azahar_emu.Azahar

# Import Flatpak overrides
cp ./configs/flatpak/org.azahar_emu.Azahar ${HOME}/.local/share/flatpak/overrides/org.azahar_emu.Azahar

log_success "Module completed successfully"
log_end
