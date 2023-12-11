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

sudo systemctl enable kernel-tweaks.service

################################################
##### Plasma
################################################

# Import Plasma color schemes
mkdir -p ${HOME}/.local/share/color-schemes
curl -O --output-dir ${HOME}/.local/share/color-schemes https://raw.githubusercontent.com/gjpin/steam-deck/main/configs/plasma/colors/HeroicGamesLauncher.colors

# Change window decorations
sudo -u ${NEW_USER} kwriteconfig5 --file kwinrc --group org.kde.kdecoration2 --key ButtonsOnLeft ""
sudo -u ${NEW_USER} kwriteconfig5 --file kwinrc --group org.kde.kdecoration2 --key ShowToolTips --type bool false

# Disable app launch feedback
sudo -u ${NEW_USER} kwriteconfig5 --file klaunchrc --group BusyCursorSettings --key "Bouncing" --type bool false
sudo -u ${NEW_USER} kwriteconfig5 --file klaunchrc --group FeedbackStyle --key "BusyCursor" --type bool false

# Window decorations
sudo -u ${NEW_USER} kwriteconfig5 --file kwinrulesrc --group 1 --key Description "Application settings for heroic"
sudo -u ${NEW_USER} kwriteconfig5 --file kwinrulesrc --group 1 --key decocolor "HeroicGamesLauncher"
sudo -u ${NEW_USER} kwriteconfig5 --file kwinrulesrc --group 1 --key decocolorrule 2
sudo -u ${NEW_USER} kwriteconfig5 --file kwinrulesrc --group 1 --key wmclass "heroic"
sudo -u ${NEW_USER} kwriteconfig5 --file kwinrulesrc --group 1 --key clientmachine "localhost"
sudo -u ${NEW_USER} kwriteconfig5 --file kwinrulesrc --group 1 --key wmclassmatch 1


################################################
##### Flatpak
################################################

# References:
# https://docs.flatpak.org/en/latest/sandbox-permissions.html
# https://docs.flatpak.org/en/latest/sandbox-permissions-reference.html#filesystem-permissions

# Add Flathub repo
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak remote-modify flathub --enable

# Import global Flatpak overrides
mkdir -p ${HOME}/.local/share/flatpak/overrides
curl https://raw.githubusercontent.com/gjpin/steam-deck/main/configs/flatpak/global -o ${HOME}/.local/share/flatpak/overrides/global

# Install Flatpak runtimes
flatpak install -y flathub org.freedesktop.Platform.ffmpeg-full/x86_64/23.08
flatpak install -y flathub org.freedesktop.Platform.GStreamer.gstreamer-vaapi/x86_64/23.08

# Install applications
flatpak install -y flathub com.github.tchx84.Flatseal
flatpak install -y flathub com.moonlight_stream.Moonlight

################################################
##### GTK theming
################################################

# Install GTK themes
flatpak install -y flathub org.gtk.Gtk3theme.Breeze org.gtk.Gtk3theme.adw-gtk3 org.gtk.Gtk3theme.adw-gtk3-dark

# Install Gradience
flatpak install -y flathub com.github.GradienceTeam.Gradience

# Import Gradience Flatpak overrides
curl https://raw.githubusercontent.com/gjpin/steam-deck/main/configs/flatpak/com.github.GradienceTeam.Gradience -o ${HOME}/.local/share/flatpak/overrides/com.github.GradienceTeam.Gradience

# Apply Breeze Dark theme to GTK applications
mkdir -p ${HOME}/.config/{gtk-3.0,gtk-4.0}
curl https://raw.githubusercontent.com/gjpin/steam-deck/main/configs/gtk/gtk.css -o ${HOME}/.config/gtk-3.0/gtk.css
curl https://raw.githubusercontent.com/gjpin/steam-deck/main/configs/gtk/gtk.css -o ${HOME}/.config/gtk-4.0/gtk.css

################################################
##### Heroic Games Launcher
################################################

# Install Heroic Games Launcher
flatpak install -y flathub com.heroicgameslauncher.hgl

# Create directory for Heroic games
mkdir -p ${HOME}/Games/Heroic

# Create Documents folder
mkdir -p ${HOME}/Games/Heroic/Prefixes/default/drive_c/users/${USER}/Documents

# Import Flatpak overrides
curl https://raw.githubusercontent.com/gjpin/steam-deck/main/configs/flatpak/com.heroicgameslauncher.hgl -o ${HOME}/.local/share/flatpak/overrides/com.heroicgameslauncher.hgl

# Configure MangoHud for Heroic
mkdir -p ${HOME}/.var/app/com.heroicgameslauncher.hgl/config/MangoHud
tee ${HOME}/.var/app/com.heroicgameslauncher.hgl/config/MangoHud/MangoHud.conf << EOF
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

################################################
##### Firefox
################################################

# Install Firefox
flatpak install -y flathub org.mozilla.firefox

# Set Firefox as default browser and handler for http/s
xdg-settings set default-web-browser org.mozilla.firefox.desktop
xdg-mime default org.mozilla.firefox.desktop x-scheme-handler/http
xdg-mime default org.mozilla.firefox.desktop x-scheme-handler/https

# Temporarily open firefox to create profile folder
timeout 5 flatpak run org.mozilla.firefox --headless

# Set Firefox profile path
export FIREFOX_PROFILE_PATH=$(find ${HOME}/.var/app/org.mozilla.firefox/.mozilla/firefox -type d -name "*.default-release")

# Import extensions
mkdir -p ${FIREFOX_PROFILE_PATH}/extensions
curl https://addons.mozilla.org/firefox/downloads/file/4003969/ublock_origin-latest.xpi -o ${FIREFOX_PROFILE_PATH}/extensions/uBlock0@raymondhill.net.xpi
curl https://addons.mozilla.org/firefox/downloads/file/3932862/multi_account_containers-latest.xpi -o ${FIREFOX_PROFILE_PATH}/extensions/@testpilot-containers.xpi

# Import Firefox configs
curl https://raw.githubusercontent.com/gjpin/steam-deck/main/configs/firefox/user.js -o ${FIREFOX_PROFILE_PATH}/user.js

################################################
##### NFS
################################################

# Add NFS mount script
tee ${HOME}/.local/bin/nfs-mount << EOF
mkdir -p ${HOME}/nfs/games/library-wireguard
mkdir -p ${HOME}/nfs/games/library-lan

if pacman -Qi nfs-utils; then
  sudo mount -t nfs -o noatime,nodiratime,rsize=131072,wsize=131072,timeo=600,retrans=2,vers=4 10.0.0.2:/srv/nfs/games/library ${HOME}/nfs/games/library-wireguard
else
  sudo pacman -Syu
  sudo steamos-readonly disable
  sudo pacman-key --init
  sudo pacman-key --populate
  sudo pacman -S --noconfirm nfs-utils
  sudo steamos-readonly enable
fi
EOF

# Make NFS mount script executable
chmod +x tee ${HOME}/.local/bin/nfs-mount

# Create NFS mount desktop entry
tee ${HOME}/Desktop/NFS-Mount.desktop << EOF
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