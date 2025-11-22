#!/usr/bin/bash
# Source logging functions
source lib/logging.sh

log_start

# Create common directories
mkdir -p \
    ${HOME}/.ssh \
    ${HOME}/.local/share/themes \
    ${HOME}/.local/bin \
    ${HOME}/.local/share/flatpak/overrides \
    ${HOME}/.config/systemd/user

# Correct .ssh permissions
chmod 700 ${HOME}/.ssh
touch ${HOME}/.ssh/authorized_keys
chmod 600 ${HOME}/.ssh/authorized_keys

# Create WireGuard folder
sudo mkdir -p /etc/wireguard
sudo chmod 700 /etc/wireguard

log_success "Module completed successfully"
log_end
