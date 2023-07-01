# Set user password
passwd

# Create common folders
mkdir -p ${HOME}/.config/systemd/user/
mkdir -p ${HOME}/.local/bin

# Install flatpaks
flatpak install flathub com.heroicgameslauncher.hgl
flatpak install flathub net.davidotek.pupgui2

################################################
##### SSH
################################################

# Create SSHD config
sudo tee /etc/ssh/sshd_config << EOF
Port 22
PermitRootLogin no
AuthorizedKeysFile      .ssh/authorized_keys
PasswordAuthentication no
PermitEmptyPasswords no
UsePAM yes
PrintMotd no
EOF

# Add public key to ${HOME}/.ssh/authorized_keys

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