#!/usr/bin/bash
# Source logging functions
source lib/logging.sh

log_start

# Instal mGBA
sudo flatpak install -y flathub io.mgba.mGBA

# Import Flatpak overrides
cp ./configs/flatpak/io.mgba.mGBA ${HOME}/.local/share/flatpak/overrides/io.mgba.mGBA

# Create mGBA directories
mkdir -p ${HOME}/Games/Emulation/roms/gba
mkdir -p ${HOME}/Games/Emulation/data/mgba/{states,cheats,screenshots,saves,patches}
mkdir -p ${HOME}/Games/Emulation/saves/mgba
mkdir -p ${HOME}/Games/Emulation/states/mgba

# Import mGBA configurations
# mkdir -p ${HOME}/.var/app/io.mgba.mGBA/config/mgba
# envsubst < ./configs/mgba/config.ini | tee ${HOME}/.var/app/io.mgba.mGBA/config/mgba/config.ini
# envsubst < ./configs/mgba/qt.ini | tee ${HOME}/.var/app/io.mgba.mGBA/config/mgba/qt.ini

log_success "Module completed successfully"
log_end
