#!/usr/bin/bash
# Source logging functions
source lib/logging.sh

log_start

# Create base directories
mkdir -p ${HOME}/Games/Emulation/{data,saves}

# Create bios directory
mkdir -p ${HOME}/Games/Emulation/bios/{psx,ps2,ps3,nds,dc}

# Create roms directories
mkdir -p ${HOME}/Games/Emulation/roms/{psx,ps2,ps3,psp,gc,wii,wiiu,gba,snes,nds,n3ds,genesis,dreamcast,saturn}

log_success "Module completed successfully"
log_end
