#!/usr/bin/bash
# Source logging functions
source lib/logging.sh

log_start

# Install WiVRn
sudo flatpak install -y flathub io.github.wivrn.wivrn
cp ./configs/flatpak/io.github.wivrn.wivrn ${HOME}/.local/share/flatpak/overrides/io.github.wivrn.wivrn

log_success "Module completed successfully"
log_end
