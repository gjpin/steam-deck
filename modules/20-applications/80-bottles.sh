#!/usr/bin/bash
# Source logging functions
source lib/logging.sh

log_start

# Install Bottles
flatpak install -y flathub com.usebottles.bottles

# Create directories for Bottles
mkdir -p ${HOME}/Games/Bottles

# Import Flatpak overrides
cp ./configs/flatpak/com.usebottles.bottles ${HOME}/.local/share/flatpak/overrides/com.usebottles.bottles

# Configure MangoHud for Bottles
mkdir -p ${HOME}/.var/app/com.usebottles.bottles/config/MangoHud
cp ./configs/mangohud/MangoHud.conf ${HOME}/.var/app/com.usebottles.bottles/config/MangoHud/MangoHud.conf

log_success "Module completed successfully"
log_end
