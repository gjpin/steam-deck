#!/usr/bin/bash
# Source logging functions
source lib/logging.sh

log_start

# Install Heroic Games Launcher
sudo flatpak install -y flathub com.heroicgameslauncher.hgl
cp ./configs/flatpak/com.heroicgameslauncher.hgl ${HOME}/.local/share/flatpak/overrides/com.heroicgameslauncher.hgl

# Configure MangoHud for Heroic
mkdir -p ${HOME}/.var/app/com.heroicgameslauncher.hgl/config/MangoHud
cp ./configs/mangohud/MangoHud.conf ${HOME}/.var/app/com.heroicgameslauncher.hgl/config/MangoHud/MangoHud.conf

# Create directories for Heroic games and prefixes
mkdir -p ${HOME}/Games/Heroic/Prefixes

log_success "Module completed successfully"
log_end
