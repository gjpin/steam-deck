#!/usr/bin/bash
# Source logging functions
source lib/logging.sh

log_start

# Instal Flycast
sudo flatpak install -y flathub org.flycast.Flycast

# Import Flatpak overrides
cp ./configs/flatpak/org.flycast.Flycast ${HOME}/.local/share/flatpak/overrides/org.flycast.Flycast

# Create Flycast directories
mkdir -p ${HOME}/Games/Emulation/roms/dreamcast

# Import Flycast configurations
# mkdir -p ${HOME}/.var/app/org.flycast.Flycast/config/flycast/mappings
# envsubst < ./configs/flycast/emu.cfg | tee ${HOME}/.var/app/org.flycast.Flycast/config/flycast/emu.cfg
# cp -R ./configs/flycast/mappings/* ${HOME}/.var/app/org.flycast.Flycast/config/flycast/mappings

log_success "Module completed successfully"
log_end
