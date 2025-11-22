#!/usr/bin/bash

################################################
##### Moonlight
################################################

# Moonlight steam shortcuts
```
"/usr/bin/flatpak"

flatpak run --command="moonlight" com.moonlight_stream.Moonlight stream --help
```

## 800p
```
"run" "--branch=stable" "--arch=x86_64" "--command=moonlight" "com.moonlight_stream.Moonlight" "--resolution=1280x800" "--vsync" "--fps=60" "--bitrate=12000" "--packet-size=1392" "--display-mode=borderless" "--audio-config=stereo" "--multi-controller" "--quit-after" "--no-mouse-buttons-swap" "--no-game-optimization" "--no-audio-on-host" "--frame-pacing" "--mute-on-focus-loss" "--no-swap-gamepad-buttons" "--keep-awake" "--no-performance-overlay" "--no-hdr" "--video-codec=AV1" "--video-decoder=hardware" stream "10.100.100.250" "Desktop 800p"
```

## 1080p
```
"run" "--branch=stable" "--arch=x86_64" "--command=moonlight" "com.moonlight_stream.Moonlight" "--resolution= 1920x1080" "--vsync" "--fps=60" "--bitrate=40000" "--packet-size=1392" "--display-mode=fullscreen" "--audio-config=stereo" "--multi-controller" "--quit-after" "--no-mouse-buttons-swap" "--no-game-optimization" "--no-audio-on-host" "--frame-pacing" "--mute-on-focus-loss" "--no-swap-gamepad-buttons" "--keep-awake" "--no-performance-overlay" "--no-hdr" "--video-codec=AV1" "--video-decoder=hardware" stream "10.100.100.250" "Desktop 1080p"
```

## 1440p
```
"run" "--branch=stable" "--arch=x86_64" "--command=moonlight" "com.moonlight_stream.Moonlight" "--resolution=2560x1440" "--vsync" "--fps=60" "--bitrate=120000" "--packet-size=1392" "--display-mode=fullscreen" "--audio-config=stereo" "--multi-controller" "--quit-after" "--no-mouse-buttons-swap" "--no-game-optimization" "--no-audio-on-host" "--frame-pacing" "--mute-on-focus-loss" "--no-swap-gamepad-buttons" "--keep-awake" "--no-performance-overlay" "--no-hdr" "--video-codec=AV1" "--video-decoder=hardware" stream "10.100.100.250" "Desktop 1440p"
```

################################################
##### Tweaks
################################################

# References:
# https://github.com/CryoByte33/steam-deck-utilities/blob/main/docs/tweak-explanation.md
# https://wiki.cachyos.org/general_info/general_system_tweaks/

# Enable trim operations
sudo systemctl enable --now fstrim.timer

# Split Lock Mitigate - default: 1
echo 'kernel.split_lock_mitigate=0' | sudo tee /etc/sysctl.d/99-splitlock.conf

# Compaction Proactiveness - default: 20
echo 'vm.compaction_proactiveness=0' | sudo tee /etc/sysctl.d/99-compaction_proactiveness.conf

# Page Lock Unfairness - default: 5
echo 'vm.page_lock_unfairness=1' | sudo tee /etc/sysctl.d/99-page_lock_unfairness.conf

# Hugepage Defragmentation - default: 1
# Transparent Hugepages - default: always
# Shared Memory in Transparent Hugepages - default: never
sudo tee /etc/systemd/system/kernel-tweaks.service << 'EOF'
[Unit]
Description=Set kernel tweaks
After=multi-user.target
StartLimitBurst=0

[Service]
Type=oneshot
Restart=on-failure
ExecStart=/usr/bin/bash -c 'echo always > /sys/kernel/mm/transparent_hugepage/enabled'
ExecStart=/usr/bin/bash -c 'echo advise > /sys/kernel/mm/transparent_hugepage/shmem_enabled'
ExecStart=/usr/bin/bash -c 'echo 0 > /sys/kernel/mm/transparent_hugepage/khugepaged/defrag'

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable --now kernel-tweaks.service

################################################
##### Bottles
################################################

# Install Bottles
flatpak install -y flathub com.usebottles.bottles

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
flatpak install -y flathub net.lutris.Lutris

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