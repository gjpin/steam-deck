#!/usr/bin/bash

################################################
##### Bottles
################################################

# Install Bottles
sudo flatpak install -y flathub com.usebottles.bottles

# Allow Bottles to create application shortcuts
flatpak override --user --filesystem=xdg-data/applications com.usebottles.bottles

# Allow Bottles to access Steam folder
flatpak override --user --filesystem=home/.steam com.usebottles.bottles

# Configure MangoHud
mkdir -p ${HOME}/.var/app/com.usebottles.bottles/config/MangoHud
tee ${HOME}/.var/app/com.usebottles.bottles/config/MangoHud/MangoHud.conf << EOF
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
##### NFS
################################################

# Add NFS mount script
tee ${HOME}/.local/bin/nfs-mount << 'EOF'
mkdir -p ${HOME}/nfs/games/library-wireguard
sudo mount -t nfs -o noatime,nodiratime,rsize=131072,wsize=131072,timeo=600,retrans=2,vers=4 10.0.0.2:/srv/nfs/games/library ${HOME}/nfs/games/library-wireguard
EOF

# Make NFS mount script executable
chmod +x tee ${HOME}/.local/bin/nfs-mount

# Create NFS mount desktop entry
tee ${HOME}/Desktop/NFS-Mount.desktop << 'EOF'
[Desktop Entry]
Name=Mount NFS folders
Exec=/usr/bin/bash ${HOME}/.local/bin/nfs-mount
Icon=steamdeck-gaming-return
Terminal=true
Type=Application
StartupNotify=false
EOF

# Change desktop shortcut permissions
chmod 755 ${HOME}/Desktop/NFS-Mount.desktop