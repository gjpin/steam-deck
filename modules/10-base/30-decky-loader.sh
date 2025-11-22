#!/usr/bin/bash
# Source logging functions
source lib/logging.sh

log_start

# Install Decky Loader
# https://github.com/SteamDeckHomebrew/decky-loader

# Check if Decky Loader is already installed
if systemctl is-enabled --quiet plugin_loader 2>/dev/null; then
    log_info "Decky Loader service is already enabled, skipping."
    exit 0
fi

log_info "Installing Decky Loader..."
curl -L -o install_release.sh https://github.com/SteamDeckHomebrew/decky-installer/releases/latest/download/install_release.sh
chmod +x install_release.sh
bash install_release.sh
rm install_release.sh

log_success "Decky Loader installed successfully"
log_end
