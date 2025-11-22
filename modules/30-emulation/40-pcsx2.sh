#!/usr/bin/bash
# Source logging functions
source lib/logging.sh

log_start

# Instal PCSX2
sudo flatpak install -y flathub net.pcsx2.PCSX2

# Import Flatpak overrides
cp ./configs/flatpak/net.pcsx2.PCSX2 ${HOME}/.local/share/flatpak/overrides/net.pcsx2.PCSX2

# Create PCSX2 directories
mkdir -p ${HOME}/Games/Emulation/roms/ps2
mkdir -p ${HOME}/Games/Emulation/bios/ps2
mkdir -p ${HOME}/Games/Emulation/saves/pcsx2
mkdir -p ${HOME}/Games/Emulation/states/pcsx2
mkdir -p ${HOME}/Games/Emulation/data/pcsx2/{cache,cheats,covers,snaps,textures,videos}

# Import PCSX2 configurations
mkdir -p ${HOME}/.var/app/net.pcsx2.PCSX2/config/PCSX2/inis
envsubst < ./configs/pcsx2/PCSX2.ini > ${HOME}/.var/app/net.pcsx2.PCSX2/config/PCSX2/inis/PCSX2.ini

log_success "Module completed successfully"
log_end
