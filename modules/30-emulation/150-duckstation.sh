#!/usr/bin/bash
# Source logging functions
source lib/logging.sh

log_start

# Instal DuckStation
sudo flatpak install -y private org.duckstation.DuckStation

# Import Flatpak overrides
cp ./configs/flatpak/org.duckstation.DuckStation ${HOME}/.local/share/flatpak/overrides/org.duckstation.DuckStation

log_success "Module completed successfully"
log_end
