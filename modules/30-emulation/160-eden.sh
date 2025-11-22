#!/usr/bin/bash
# Source logging functions
source lib/logging.sh

log_start

# Instal Eden
sudo flatpak install -y private dev.edenemu.Eden

# Import Flatpak overrides
cp ./configs/flatpak/dev.edenemu.Eden ${HOME}/.local/share/flatpak/overrides/dev.edenemu.Eden

log_success "Module completed successfully"
log_end
