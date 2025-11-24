#!/usr/bin/bash
# Source logging functions
source lib/logging.sh

log_start

# Install Ludusavi
sudo flatpak install -y flathub com.github.mtkennerly.ludusavi
cp ./configs/flatpak/com.github.mtkennerly.ludusavi ${HOME}/.local/share/flatpak/overrides/com.github.mtkennerly.ludusavi

# Import Ludusavi configs
mkdir -p ${HOME}/.var/app/com.github.mtkennerly.ludusavi/config/ludusavi/{heroic,steam}
cat ./configs/ludusavi/config-heroic.yaml | envsubst > ${HOME}/.var/app/com.github.mtkennerly.ludusavi/config/ludusavi/config.yaml
cat ./configs/ludusavi/config-heroic.yaml | envsubst > ${HOME}/.var/app/com.github.mtkennerly.ludusavi/config/ludusavi/heroic/config.yaml
cat ./configs/ludusavi/config-steam.yaml | envsubst > ${HOME}/.var/app/com.github.mtkennerly.ludusavi/config/ludusavi/steam/config.yaml

################################################
##### Heroic integration
################################################

# Set automatic backups and restores when Heroic is opened/closed
# https://github.com/mtkennerly/ludusavi/blob/master/docs/help/backup-automation.md
# https://github.com/mtkennerly/ludusavi/blob/master/docs/cli.md
# Create 'heroic' watcher script
tee ${HOME}/.local/bin/ludusavi-heroic.sh << 'EOF'
#!/usr/bin/bash

PROCESS="heroic"

while true; do
    # Wait for Heroic to start
    while ! pgrep -x "$PROCESS" >/dev/null; do
        sleep 1
    done

    # --- RUN ON START ---
    # Restore save games with ludusavi
    /usr/bin/flatpak run com.github.mtkennerly.ludusavi \
        --config="$HOME/.var/app/com.github.mtkennerly.ludusavi/config/ludusavi/heroic" \
        restore --force

    # Wait for Heroic to exit
    while pgrep -x "$PROCESS" >/dev/null; do
        sleep 1
    done

    # --- RUN ON EXIT ---
    # Backup save games with ludusavi
    /usr/bin/flatpak run com.github.mtkennerly.ludusavi \
        --config="$HOME/.var/app/com.github.mtkennerly.ludusavi/config/ludusavi/heroic" \
        backup --force

    # Loop again to watch for next launch
done
EOF

chmod +x ${HOME}/.local/bin/ludusavi-heroic.sh

# Create systemd service
tee ${HOME}/.config/systemd/user/ludusavi-heroic.service << EOF
[Unit]
Description=Ludusavi - Heroic

[Service]
Type=simple
ExecStart=%h/.local/bin/ludusavi-heroic.sh
Restart=always
RestartSec=1

[Install]
WantedBy=default.target
EOF

# Enable systemd service
systemctl --user daemon-reload
systemctl --user enable ludusavi-heroic.service

################################################
##### Steam integration
################################################

# Set automatic backups for Steam save games
# https://github.com/mtkennerly/ludusavi/blob/master/docs/help/backup-automation.md
tee ~/.config/systemd/user/ludusavi-steam.service << 'EOF'
[Unit]
Description="Ludusavi - Steam"

[Service]
ExecStart=/usr/bin/flatpak run com.github.mtkennerly.ludusavi --config="$HOME/.var/app/com.github.mtkennerly.ludusavi/config/ludusavi/steam" backup --force
EOF

tee ~/.config/systemd/user/ludusavi-steam.timer << 'EOF'
[Unit]
Description="Ludusavi - Steam timer"

[Timer]
OnCalendar=hourly
Unit=ludusavi-backup.service

[Install]
WantedBy=timers.target
EOF

systemctl --user enable ${HOME}/.config/systemd/user/ludusavi-steam.timer

log_success "Module completed successfully"
log_end
