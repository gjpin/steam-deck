#!/usr/bin/bash
# Source logging functions
source lib/logging.sh

log_start

# Install ProtonPlus
flatpak install -y flathub org.prismlauncher.PrismLauncher

# Import Flatpak overrides
cp ./configs/flatpak/org.prismlauncher.PrismLauncher ${HOME}/.local/share/flatpak/overrides/org.prismlauncher.PrismLauncher

log_success "Module completed successfully"
log_end
