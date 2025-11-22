#!/usr/bin/bash
# Source logging functions
source lib/logging.sh

log_start

# Instal RetroArch
sudo flatpak install -y flathub org.libretro.RetroArch

# Import Flatpak overrides
cp ./configs/flatpak/org.libretro.RetroArch ${HOME}/.local/share/flatpak/overrides/org.libretro.RetroArch

# Create RetroArch directories
mkdir -p ${HOME}/Games/Emulation/data/retroarch/{cheats,states,screenshots,downloads,cores,info,remaps,config,shaders,overlays,playlists}
mkdir -p ${HOME}/Games/Emulation/saves/retroarch
mkdir -p ${HOME}/Games/Emulation/states/retroarch

# Import RetroArch configurations
# mkdir -p ${HOME}/.var/app/org.libretro.RetroArch/config/retroarch
# cp -R ./configs/retroarch/config/* ${HOME}/Games/Emulation/data/retroarch/config
# cp -R ./configs/retroarch/cores/* ${HOME}/Games/Emulation/data/retroarch/cores
# cp -R ./configs/retroarch/info/* ${HOME}/Games/Emulation/data/retroarch/info
# cp -R ./configs/retroarch/overlays/* ${HOME}/Games/Emulation/data/retroarch/overlays
# envsubst < ./configs/retroarch/retroarch.cfg | tee ${HOME}/.var/app/org.libretro.RetroArch/config/retroarch/retroarch.cfg

log_success "Module completed successfully"
log_end
