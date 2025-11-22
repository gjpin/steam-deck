#!/usr/bin/bash
# Source logging functions
source lib/logging.sh

log_start

# Instal Dolphin
sudo flatpak install -y flathub org.DolphinEmu.dolphin-emu

# Import Flatpak overrides
cp ./configs/flatpak/org.DolphinEmu.dolphin-emu ${HOME}/.local/share/flatpak/overrides/org.DolphinEmu.dolphin-emu

# Create Dolphin directories
mkdir -p ${HOME}/Games/Emulation/bios/gc
mkdir -p ${HOME}/Games/Emulation/roms/{gc,wii}

# Import Dolphin configurations
# mkdir -p ${HOME}/.var/app/org.DolphinEmu.dolphin-emu/config/dolphin-emu
# cp -R ./configs/dolphin/* ${HOME}/.var/app/org.DolphinEmu.dolphin-emu/config/dolphin-emu
# envsubst < ./configs/dolphin/Dolphin.ini | tee ${HOME}/.var/app/org.DolphinEmu.dolphin-emu/config/dolphin-emu/Dolphin.ini

log_success "Module completed successfully"
log_end
