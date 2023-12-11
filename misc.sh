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