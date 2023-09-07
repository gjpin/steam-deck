#!/usr/bin/bash

# Create common folders
mkdir -p ${HOME}/.config/systemd/user/
mkdir -p ${HOME}/.local/bin

################################################
##### Bash
################################################

# Create directory for custom bash entries
mkdir -p ${HOME}/.bashrc.d

# Configure bash
tee -a ${HOME}/.bashrc << 'EOF'

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
        for rc in ~/.bashrc.d/*; do
                if [ -f "$rc" ]; then
                        . "$rc"
                fi
        done
fi

unset rc
EOF

################################################
##### Flatpak
################################################

# References:
# https://docs.flatpak.org/en/latest/sandbox-permissions.html
# https://docs.flatpak.org/en/latest/sandbox-permissions-reference.html#filesystem-permissions

# Add Flathub repo
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak remote-modify flathub --enable

# Restrict filesystem access
flatpak override --user --nofilesystem=home
flatpak override --user --nofilesystem=home/.ssh
flatpak override --user --nofilesystem=home/.bashrc
flatpak override --user --nofilesystem=home/.bashrc.d
flatpak override --user --nofilesystem=home/.config
flatpak override --user --nofilesystem=home/Sync
flatpak override --user --nofilesystem=host
flatpak override --user --nofilesystem=host-os
flatpak override --user --nofilesystem=host-etc
flatpak override --user --nofilesystem=xdg-config
flatpak override --user --nofilesystem=xdg-cache
flatpak override --user --nofilesystem=xdg-data
flatpak override --user --nofilesystem=xdg-data/flatpak
flatpak override --user --nofilesystem=xdg-documents
flatpak override --user --nofilesystem=xdg-videos
flatpak override --user --nofilesystem=xdg-music
flatpak override --user --nofilesystem=xdg-pictures
flatpak override --user --nofilesystem=xdg-desktop

# Restrict talk
flatpak override --user --no-talk-name=org.freedesktop.Flatpak

# Filesystem access exemptions
flatpak override --user --filesystem=xdg-download
flatpak override --user --filesystem=xdg-config/gtk-3.0:ro
flatpak override --user --filesystem=xdg-config/gtk-4.0:ro

# Install applications
sudo flatpak install -y flathub com.github.tchx84.Flatseal
sudo flatpak install -y flathub net.davidotek.pupgui2
sudo flatpak install -y flathub com.moonlight_stream.Moonlight

################################################
##### Heroic Games Launcher
################################################

# Install Heroic Games Launcher
sudo flatpak install -y flathub com.heroicgameslauncher.hgl

# Allow Heroic to access external directory and steam folder
flatpak override --user --filesystem=home/Games/Heroic com.heroicgameslauncher.hgl
flatpak override --user --filesystem=home/.steam com.heroicgameslauncher.hgl

################################################
##### Lutris
################################################

# Install Lutris
sudo flatpak install -y flathub net.lutris.Lutris

# Allow Lutris to create application shortcuts
flatpak override --user --filesystem=xdg-data/applications net.lutris.Lutris

# Allow Lutris access to its folder
flatpak override --user --filesystem=home/Games/lutris net.lutris.Lutris

# Allow Lutris access to Steam
flatpak override --user --filesystem=home/.steam net.lutris.Lutris

# Deny Lutris talk
flatpak override --user --no-talk-name=org.freedesktop.Flatpak net.lutris.Lutris

# Deny Lutris internet access
flatpak override --user --unshare=network net.lutris.Lutris

# Configure MangoHud
mkdir -p ${HOME}/.var/app/net.lutris.Lutris/config/MangoHud
tee ${HOME}/.var/app/net.lutris.Lutris/config/MangoHud/MangoHud.conf << EOF
legacy_layout=0
horizontal
gpu_stats
cpu_stats
ram
fps
frametime=0
hud_no_margin
table_columns=14
frame_timing=1
engine_version
vulkan_driver
EOF

################################################
##### Syncthing
################################################

# Download and install latest Syncthing release
LATEST_VERSION=$(curl -s https://api.github.com/repos/syncthing/syncthing/releases/latest | awk -F\" '/tag_name/{print $(NF-1)}')
DOWNLOAD_URL=$(curl -L -s https://api.github.com/repos/syncthing/syncthing/releases/latest | grep -o -E "https://(.*)syncthing-linux-amd64-v(.*).tar.gz")
curl -sSL ${DOWNLOAD_URL} -O
tar -zxvf syncthing-linux-amd64-${LATEST_VERSION}.tar.gz -C ${HOME}/.local/bin syncthing-linux-amd64-${LATEST_VERSION}/syncthing --strip-components=1
rm -f syncthing-linux-amd64-${LATEST_VERSION}.tar.gz

# Syncthing updater
tee ${HOME}/.local/bin/update-syncthing << 'EOF'
#!/usr/bin/bash
set -e

LATEST_VERSION=$(curl -s https://api.github.com/repos/syncthing/syncthing/releases/latest | awk -F\" '/tag_name/{print $(NF-1)}')
DOWNLOAD_URL=$(curl -L -s https://api.github.com/repos/syncthing/syncthing/releases/latest | grep -o -E "https://(.*)syncthing-linux-amd64-v(.*).tar.gz")
curl -sSL ${DOWNLOAD_URL} -O
rm ${HOME}/.local/bin/syncthing
tar -zxvf syncthing-linux-amd64-${LATEST_VERSION}.tar.gz -C ${HOME}/.local/bin syncthing-linux-amd64-${LATEST_VERSION}/syncthing --strip-components=1
rm -f syncthing-linux-amd64-${LATEST_VERSION}.tar.gz
EOF

chmod +x ${HOME}/.local/bin/update-syncthing

# Add Syncthing service
tee ${HOME}/.config/systemd/user/syncthing.service << EOF
[Unit]
Description=Syncthing - Open Source Continuous File Synchronization
Documentation=man:syncthing(1)
StartLimitIntervalSec=60
StartLimitBurst=4

[Service]
ExecStart=${HOME}/.local/bin/syncthing serve --no-browser --no-restart --logflags=0
Restart=on-failure
RestartSec=1
SuccessExitStatus=3 4
RestartForceExitStatus=3 4

# Hardening
SystemCallArchitectures=native
MemoryDenyWriteExecute=true
NoNewPrivileges=true

[Install]
WantedBy=default.target
EOF

systemctl --user enable --now syncthing.service