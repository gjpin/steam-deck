#!/usr/bin/bash
# Source logging functions
source lib/logging.sh

log_start

# Instal ES-DE
sudo flatpak install -y private org.es.ES-DE

# Import Flatpak overrides
cp ./configs/flatpak/org.es.ES-DE ${HOME}/.local/share/flatpak/overrides/org.es.ES-DE

log_success "Module completed successfully"
log_end
