#!/usr/bin/bash

# Create common folders
mkdir -p ${HOME}/.config/systemd/user/
mkdir -p ${HOME}/.local/bin

# Install flatpaks
flatpak install flathub com.heroicgameslauncher.hgl
flatpak install flathub net.davidotek.pupgui2
flatpak install flathub com.moonlight_stream.Moonlight

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
##### Backup Heroic saves from Deck to Syncthing
################################################

# Create backups script
tee ${HOME}/.local/bin/backup-heroic-saves.sh << EOF
#!/usr/bin/bash
rsync -r "/home/deck/Games/Heroic/Prefixes/default/Remnant From the Ashes/pfx/drive_c/users/steamuser/AppData/Local/Remnant/Saved/SaveGames"/. /home/deck/syncthing/saves/heroic/remnant_from_the_ashes
rsync -r "/home/deck/Games/Heroic/Prefixes/default/The Pathless/pfx/drive_c/users/steamuser/AppData/Local/Pathless/Saved/SaveGames"/. /home/deck/syncthing/saves/heroic/the_pathless
rsync -r "/home/deck/Games/Heroic/Prefixes/default/Solar Ash/pfx/drive_c/users/steamuser/AppData/Local/Solar/EGS/619ea35adadd4d6cb8fea37060af796c/SaveGames"/. /home/deck/syncthing/saves/heroic/solar_ash
rsync -r "/home/deck/Games/Heroic/Prefixes/default/Wonder Boy The Dragons Trap/pfx/drive_c/users/steamuser/AppData/Local/Lizardcube/The Dragon's Trap"/. /home/deck/syncthing/saves/heroic/wonder_boy_the_dragons_trap
rsync -r "/home/deck/Games/Heroic/Prefixes/default/Shadow Tactics Blades of the Shogun/pfx/drive_c/users/steamuser/AppData/Local/Daedalic Entertainment GmbH/Shadow Tactics Blades of the Shogun Aikos Choice/user"/. /home/deck/syncthing/saves/heroic/shadow_tactics_blades_of_the_shogun_aikos_choice
rsync -r "/home/deck/Games/Heroic/Prefixes/default/Scourgebringer/pfx/drive_c/users/steamuser/AppData/LocalLow/Flying Oak Games/ScourgeBringer"/. /home/deck/syncthing/saves/heroic/scourgebringer
rsync -r "/home/deck/Games/Heroic/Prefixes/default/Void Bastards/pfx/drive_c/users/steamuser/AppData/LocalLow/BlueManchu/VoidBastards"/. /home/deck/syncthing/saves/heroic/void_bastards
rsync -r "/home/deck/Games/Heroic/Prefixes/default/Cris Tales/pfx/drive_c/users/steamuser/AppData/LocalLow/Dreams Uncorpored LLC/Cristales"/. /home/deck/syncthing/saves/heroic/cris_tales
rsync -r "/home/deck/Games/Heroic/Prefixes/default/Dandara Trials of Fear Edition/pfx/drive_c/users/steamuser/AppData/LocalLow/Long Hat House/Dandara"/. /home/deck/syncthing/saves/heroic/dandara_trials_of_fear_edition
rsync -r "/home/deck/Games/Heroic/Prefixes/default/Sable/pfx/drive_c/users/steamuser/AppData/LocalLow/Shedworks/Sable"/. /home/deck/syncthing/saves/heroic/sable
rsync -r "/home/deck/Games/Heroic/Prefixes/default/Hell is Others/pfx/drive_c/users/steamuser/AppData/LocalLow/Strelka Games/Hell Is Others/EGS/619ea35adadd4d6cb8fea37060af796c/Saves"/. /home/deck/syncthing/saves/heroic/hell_is_others
rsync -r "/home/deck/Games/Heroic/Prefixes/default/Into The Breach/pfx/drive_c/users/steamuser/Documents/My Games/Into The Breach"/. /home/deck/syncthing/saves/heroic/into_the_breach
rsync -r "/home/deck/Games/Heroic/Prefixes/default/Hob/pfx/drive_c/users/steamuser/Documents/My Games/Runic Games/Hob/SAVES"/. /home/deck/syncthing/saves/heroic/hob
rsync -r "/home/deck/Games/Heroic/Prefixes/default/Torchlight II/pfx/drive_c/users/steamuser/Documents/My Games/Runic Games/Torchlight 2/save"/. /home/deck/syncthing/saves/heroic/torchlight_ii
EOF

chmod +x ${HOME}/.local/bin/backup-heroic-saves.sh

# Create backups systemd service
tee ${HOME}/.config/systemd/user/backup-heroic-saves.path << EOF
[Unit]
Description="Monitor the Heroic save directories for changes"

[Path]
PathChanged=/home/deck/Games/Heroic/Prefixes/default/Remnant From the Ashes/pfx/drive_c/users/steamuser/AppData/Local/Remnant/Saved/SaveGames
PathChanged=/home/deck/Games/Heroic/Prefixes/default/The Pathless/pfx/drive_c/users/steamuser/AppData/Local/Pathless/Saved/SaveGames
PathChanged=/home/deck/Games/Heroic/Prefixes/default/Solar Ash/pfx/drive_c/users/steamuser/AppData/Local/Solar/EGS/619ea35adadd4d6cb8fea37060af796c/SaveGames
PathChanged=/home/deck/Games/Heroic/Prefixes/default/Wonder Boy The Dragons Trap/pfx/drive_c/users/steamuser/AppData/Local/Lizardcube/The Dragon's Trap
PathChanged=/home/deck/Games/Heroic/Prefixes/default/Shadow Tactics Blades of the Shogun/pfx/drive_c/users/steamuser/AppData/Local/Daedalic Entertainment GmbH/Shadow Tactics Blades of the Shogun Aikos Choice/user
PathChanged=/home/deck/Games/Heroic/Prefixes/default/Scourgebringer/pfx/drive_c/users/steamuser/AppData/LocalLow/Flying Oak Games/ScourgeBringer
PathChanged=/home/deck/Games/Heroic/Prefixes/default/Void Bastards/pfx/drive_c/users/steamuser/AppData/LocalLow/BlueManchu/VoidBastards
PathChanged=/home/deck/Games/Heroic/Prefixes/default/Cris Tales/pfx/drive_c/users/steamuser/AppData/LocalLow/Dreams Uncorpored LLC/Cristales
PathChanged=/home/deck/Games/Heroic/Prefixes/default/Dandara Trials of Fear Edition/pfx/drive_c/users/steamuser/AppData/LocalLow/Long Hat House/Dandara
PathChanged=/home/deck/Games/Heroic/Prefixes/default/Sable/pfx/drive_c/users/steamuser/AppData/LocalLow/Shedworks/Sable
PathChanged=/home/deck/Games/Heroic/Prefixes/default/Hell is Others/pfx/drive_c/users/steamuser/AppData/LocalLow/Strelka Games/Hell Is Others/EGS/619ea35adadd4d6cb8fea37060af796c/Saves
PathChanged=/home/deck/Games/Heroic/Prefixes/default/Into The Breach/pfx/drive_c/users/steamuser/Documents/My Games/Into The Breach
PathChanged=/home/deck/Games/Heroic/Prefixes/default/Hob/pfx/drive_c/users/steamuser/Documents/My Games/Runic Games/Hob/SAVES
PathChanged=/home/deck/Games/Heroic/Prefixes/default/Torchlight II/pfx/drive_c/users/steamuser/Documents/My Games/Runic Games/Torchlight 2/save
TriggerLimitBurst=0

[Install]
WantedBy=default.target
EOF

tee ${HOME}/.config/systemd/user/backup-heroic-saves.service << EOF
[Unit]
Description="Backup the Heroic save directories"

[Service]
ExecStart=${HOME}/.local/bin/backup-heroic-saves.sh
EOF

# Enable backups systemd service
systemctl --user enable --now backup-heroic-saves.path

################################################
##### Restore Heroic saves from Syncthing to Deck
################################################

# Create restore script
tee ${HOME}/.local/bin/restore-heroic-saves.sh << EOF
#!/usr/bin/bash
rsync -r --mkpath "/home/deck/syncthing/saves/heroic/remnant_from_the_ashes/" "/home/deck/Games/Heroic/Prefixes/default/Remnant From the Ashes/pfx/drive_c/users/steamuser/AppData/Local/Remnant/Saved/SaveGames"
rsync -r --mkpath "/home/deck/syncthing/saves/heroic/the_pathless/" "/home/deck/Games/Heroic/Prefixes/default/The Pathless/pfx/drive_c/users/steamuser/AppData/Local/Pathless/Saved/SaveGames"
rsync -r --mkpath "/home/deck/syncthing/saves/heroic/solar_ash/" "/home/deck/Games/Heroic/Prefixes/default/Solar Ash/pfx/drive_c/users/steamuser/AppData/Local/Solar/EGS/619ea35adadd4d6cb8fea37060af796c/SaveGames"
rsync -r --mkpath "/home/deck/syncthing/saves/heroic/wonder_boy_the_dragons_trap/" "/home/deck/Games/Heroic/Prefixes/default/Wonder Boy The Dragons Trap/pfx/drive_c/users/steamuser/AppData/Local/Lizardcube/The Dragon's Trap"
rsync -r --mkpath "/home/deck/syncthing/heroic/shadow_tactics_blades_of_the_shogun_aikos_choice/" "/home/deck/Games/Heroic/Prefixes/default/Shadow Tactics Blades of the Shogun/pfx/drive_c/users/steamuser/AppData/Local/Daedalic Entertainment GmbH/Shadow Tactics Blades of the Shogun Aikos Choice/user"
rsync -r --mkpath "/home/deck/syncthing/heroic/scourgebringer/" "/home/deck/Games/Heroic/Prefixes/default/Scourgebringer/pfx/drive_c/users/steamuser/AppData/LocalLow/Flying Oak Games/ScourgeBringer"
rsync -r --mkpath "/home/deck/syncthing/heroic/void_bastards/" "/home/deck/Games/Heroic/Prefixes/default/Void Bastards/pfx/drive_c/users/steamuser/AppData/LocalLow/BlueManchu/VoidBastards"
rsync -r --mkpath "/home/deck/syncthing/heroic/cris_tales/" "/home/deck/Games/Heroic/Prefixes/default/Cris Tales/pfx/drive_c/users/steamuser/AppData/LocalLow/Dreams Uncorpored LLC/Cristales"
rsync -r --mkpath "/home/deck/syncthing/heroic/dandara_trials_of_fear_edition/" "/home/deck/Games/Heroic/Prefixes/default/Dandara Trials of Fear Edition/pfx/drive_c/users/steamuser/AppData/LocalLow/Long Hat House/Dandara"
rsync -r --mkpath "/home/deck/syncthing/heroic/sable/" "/home/deck/Games/Heroic/Prefixes/default/Sable/pfx/drive_c/users/steamuser/AppData/LocalLow/Shedworks/Sable"
rsync -r --mkpath "/home/deck/syncthing/heroic/hell_is_others/" "/home/deck/Games/Heroic/Prefixes/default/Hell is Others/pfx/drive_c/users/steamuser/AppData/LocalLow/Strelka Games/Hell Is Others/EGS/619ea35adadd4d6cb8fea37060af796c/Saves"
rsync -r --mkpath "/home/deck/syncthing/heroic/into_the_breach/" "/home/deck/Games/Heroic/Prefixes/default/Into The Breach/pfx/drive_c/users/steamuser/Documents/My Games/Into The Breach"
rsync -r --mkpath "/home/deck/syncthing/heroic/hob/" "/home/deck/Games/Heroic/Prefixes/default/Hob/pfx/drive_c/users/steamuser/Documents/My Games/Runic Games/Hob/SAVES"
rsync -r --mkpath "/home/deck/syncthing/heroic/torchlight_ii/" "/home/deck/Games/Heroic/Prefixes/default/Torchlight II/pfx/drive_c/users/steamuser/Documents/My Games/Runic Games/Torchlight 2/save"
EOF

chmod +x ${HOME}/.local/bin/restore-heroic-saves.sh

# Create restore systemd service
tee ${HOME}/.config/systemd/user/restore-heroic-saves.path << EOF
[Unit]
Description="Monitor the Heroic save directories for changes"

[Path]
PathChanged=/home/deck/syncthing/saves/heroic/remnant_from_the_ashes
PathChanged=/home/deck/syncthing/saves/heroic/the_pathless
PathChanged=/home/deck/syncthing/saves/heroic/solar_ash
PathChanged=/home/deck/syncthing/saves/heroic/wonder_boy_the_dragons_trap
PathChanged=/home/deck/syncthing/saves/heroic/shadow_tactics_blades_of_the_shogun_aikos_choice
PathChanged=/home/deck/syncthing/saves/heroic/scourgebringer
PathChanged=/home/deck/syncthing/saves/heroic/void_bastards
PathChanged=/home/deck/syncthing/saves/heroic/cris_tales
PathChanged=/home/deck/syncthing/saves/heroic/dandara_trials_of_fear_edition
PathChanged=/home/deck/syncthing/saves/heroic/sable
PathChanged=/home/deck/syncthing/saves/heroic/hell_is_others
PathChanged=/home/deck/syncthing/saves/heroic/into_the_breach
PathChanged=/home/deck/syncthing/saves/heroic/hob
PathChanged=/home/deck/syncthing/saves/heroic/torchlight_ii
TriggerLimitBurst=0

[Install]
WantedBy=default.target
EOF

tee ${HOME}/.config/systemd/user/restore-heroic-saves.service << EOF
[Unit]
Description="Restore the Heroic save directories"

[Service]
ExecStart=${HOME}/.local/bin/restore-heroic-saves.sh
EOF

# Enable restore systemd service
systemctl --user enable --now restore-heroic-saves.path