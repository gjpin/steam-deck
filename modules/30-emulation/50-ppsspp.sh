#!/usr/bin/bash
# Source logging functions
source lib/logging.sh

log_start

# Instal PPSSPP
sudo flatpak install -y flathub org.ppsspp.PPSSPP

# Import Flatpak overrides
cp ./configs/flatpak/org.ppsspp.PPSSPP ${HOME}/.local/share/flatpak/overrides/org.ppsspp.PPSSPP

# Create PPSSPP directories
mkdir -p ${HOME}/Games/Emulation/roms/psp
mkdir -p ${HOME}/Games/Emulation/saves/ppsspp

# Import PPSSPP configurations
# mkdir -p ${HOME}/.var/app/org.ppsspp.PPSSPP/config/ppsspp/PSP/SYSTEM
# envsubst < ./configs/ppsspp/controls.ini > ${HOME}/.var/app/org.ppsspp.PPSSPP/config/ppsspp/PSP/SYSTEM/controls.ini
# envsubst < ./configs/ppsspp/ppsspp.ini > ${HOME}/.var/app/org.ppsspp.PPSSPP/config/ppsspp/PSP/SYSTEM/ppsspp.ini

log_success "Module completed successfully"
log_end
