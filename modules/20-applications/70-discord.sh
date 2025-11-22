#!/usr/bin/bash
# Source logging functions
source lib/logging.sh

log_start

# Install Discord
sudo flatpak install -y flathub com.discordapp.Discord
cp ./configs/flatpak/com.discordapp.Discord ${HOME}/.local/share/flatpak/overrides/com.discordapp.Discord

log_success "Module completed successfully"
log_end
