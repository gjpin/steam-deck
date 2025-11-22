#!/usr/bin/bash
# Source logging functions
source lib/logging.sh

log_start

# Instal Snes9x
sudo flatpak install -y flathub com.snes9x.Snes9x

# Import Flatpak overrides
cp ./configs/flatpak/com.snes9x.Snes9x ${HOME}/.local/share/flatpak/overrides/com.snes9x.Snes9x

log_success "Module completed successfully"
log_end
