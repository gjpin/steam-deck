################################################
##### Restore Heroic saves from Syncthing to Desktop
################################################

# Create restore script
tee ${HOME}/.local/bin/restore-heroic-saves.sh << EOF
#!/usr/bin/bash
rsync -r --mkpath "/data/games/saves/heroic/remnant_from_the_ashes/" "/data/games/heroic/prefixes/default/Remnant From the Ashes/drive_c/users/${USER}/AppData/Local/Remnant/Saved/SaveGames"
rsync -r --mkpath "/data/games/saves/heroic/the_pathless/" "/data/games/heroic/prefixes/default/The Pathless/drive_c/users/${USER}/AppData/Local/Pathless/Saved/SaveGames"
rsync -r --mkpath "/data/games/saves/heroic/solar_ash/" "/data/games/heroic/prefixes/default/Solar Ash/drive_c/users/${USER}/AppData/Local/Solar/EGS/619ea35adadd4d6cb8fea37060af796c/SaveGames"
rsync -r --mkpath "/data/games/saves/heroic/wonder_boy_the_dragons_trap/" "/data/games/heroic/prefixes/default/Wonder Boy The Dragons Trap/drive_c/users/${USER}/AppData/Local/Lizardcube/The Dragon's Trap"
rsync -r --mkpath "/data/games/saves/heroic/shadow_tactics_blades_of_the_shogun_aikos_choice/" "/data/games/heroic/prefixes/default/Shadow Tactics Blades of the Shogun/drive_c/users/${USER}/AppData/Local/Daedalic Entertainment GmbH/Shadow Tactics Blades of the Shogun Aikos Choice/user"
rsync -r --mkpath "/data/games/saves/heroic/scourgebringer/" "/data/games/heroic/prefixes/default/Scourgebringer/drive_c/users/${USER}/AppData/LocalLow/Flying Oak Games/ScourgeBringer"
rsync -r --mkpath "/data/games/saves/heroic/void_bastards/" "/data/games/heroic/prefixes/default/Void Bastards/drive_c/users/${USER}/AppData/LocalLow/BlueManchu/VoidBastards"
rsync -r --mkpath "/data/games/saves/heroic/cris_tales/" "/data/games/heroic/prefixes/default/Cris Tales/drive_c/users/${USER}/AppData/LocalLow/Dreams Uncorpored LLC/Cristales"
rsync -r --mkpath "/data/games/saves/heroic/dandara_trials_of_fear_edition/" "/data/games/heroic/prefixes/default/Dandara Trials of Fear Edition/drive_c/users/${USER}/AppData/LocalLow/Long Hat House/Dandara"
rsync -r --mkpath "/data/games/saves/heroic/sable/" "/data/games/heroic/prefixes/default/Sable/drive_c/users/${USER}/AppData/LocalLow/Shedworks/Sable"
rsync -r --mkpath "/data/games/saves/heroic/hell_is_others/" "/data/games/heroic/prefixes/default/Hell is Others/drive_c/users/${USER}/AppData/LocalLow/Strelka Games/Hell Is Others/EGS/619ea35adadd4d6cb8fea37060af796c/Saves"
rsync -r --mkpath "/data/games/saves/heroic/into_the_breach/" "/data/games/heroic/prefixes/default/Into The Breach/drive_c/users/${USER}/Documents/My Games/Into The Breach"
rsync -r --mkpath "/data/games/saves/heroic/hob/" "/data/games/heroic/prefixes/default/Hob/drive_c/users/${USER}/Documents/My Games/Runic Games/Hob/SAVES"
rsync -r --mkpath "/data/games/saves/heroic/torchlight_ii/" "/data/games/heroic/prefixes/default/Torchlight II/drive_c/users/${USER}/Documents/My Games/Runic Games/Torchlight 2/save"
EOF

chmod +x ${HOME}/.local/bin/restore-heroic-saves.sh

# Create restore systemd service
tee ${HOME}/.config/systemd/user/restore-heroic-saves.path << EOF
[Unit]
Description="Monitor the Heroic save directories for changes"

[Path]
PathChanged=/data/games/saves/heroic/remnant_from_the_ashes
PathChanged=/data/games/saves/heroic/the_pathless
PathChanged=/data/games/saves/heroic/solar_ash
PathChanged=/data/games/saves/heroic/wonder_boy_the_dragons_trap
PathChanged=/data/games/saves/heroic/shadow_tactics_blades_of_the_shogun_aikos_choice
PathChanged=/data/games/saves/heroic/scourgebringer
PathChanged=/data/games/saves/heroic/void_bastards
PathChanged=/data/games/saves/heroic/cris_tales
PathChanged=/data/games/saves/heroic/dandara_trials_of_fear_edition
PathChanged=/data/games/saves/heroic/sable
PathChanged=/data/games/saves/heroic/hell_is_others
PathChanged=/data/games/saves/heroic/into_the_breach
PathChanged=/data/games/saves/heroic/hob
PathChanged=/data/games/saves/heroic/torchlight_ii
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

################################################
##### Backup Heroic saves from Desktop to Syncthing
################################################

# Create backups script
tee ${HOME}/.local/bin/backup-heroic-saves.sh << EOF
#!/usr/bin/bash
rsync -r "/data/games/heroic/prefixes/default/Remnant From the Ashes/drive_c/users/${USER}/AppData/Local/Remnant/Saved/SaveGames"/. /data/games/saves/heroic/remnant_from_the_ashes
rsync -r "/data/games/heroic/prefixes/default/The Pathless/drive_c/users/${USER}/AppData/Local/Pathless/Saved/SaveGames"/. /data/games/saves/heroic/the_pathless
rsync -r "/data/games/heroic/prefixes/default/Solar Ash/drive_c/users/${USER}/AppData/Local/Solar/EGS/619ea35adadd4d6cb8fea37060af796c/SaveGames"/. /data/games/saves/heroic/solar_ash
rsync -r "/data/games/heroic/prefixes/default/Wonder Boy The Dragons Trap/drive_c/users/${USER}/AppData/Local/Lizardcube/The Dragon's Trap"/. /data/games/saves/heroic/wonder_boy_the_dragons_trap
rsync -r "/data/games/heroic/prefixes/default/Shadow Tactics Blades of the Shogun/drive_c/users/${USER}/AppData/Local/Daedalic Entertainment GmbH/Shadow Tactics Blades of the Shogun Aikos Choice/user"/. /data/games/saves/heroic/shadow_tactics_blades_of_the_shogun_aikos_choice
rsync -r "/data/games/heroic/prefixes/default/Scourgebringer/drive_c/users/${USER}/AppData/LocalLow/Flying Oak Games/ScourgeBringer"/. /data/games/saves/heroic/scourgebringer
rsync -r "/data/games/heroic/prefixes/default/Void Bastards/drive_c/users/${USER}/AppData/LocalLow/BlueManchu/VoidBastards"/. /data/games/saves/heroic/void_bastards
rsync -r "/data/games/heroic/prefixes/default/Cris Tales/drive_c/users/${USER}/AppData/LocalLow/Dreams Uncorpored LLC/Cristales"/. /data/games/saves/heroic/cris_tales
rsync -r "/data/games/heroic/prefixes/default/Dandara Trials of Fear Edition/drive_c/users/${USER}/AppData/LocalLow/Long Hat House/Dandara"/. /data/games/saves/heroic/dandara_trials_of_fear_edition
rsync -r "/data/games/heroic/prefixes/default/Sable/drive_c/users/${USER}/AppData/LocalLow/Shedworks/Sable"/. /data/games/saves/heroic/sable
rsync -r "/data/games/heroic/prefixes/default/Hell is Others/drive_c/users/${USER}/AppData/LocalLow/Strelka Games/Hell Is Others/EGS/619ea35adadd4d6cb8fea37060af796c/Saves"/. /data/games/saves/heroic/hell_is_others
rsync -r "/data/games/heroic/prefixes/default/Into The Breach/drive_c/users/${USER}/Documents/My Games/Into The Breach"/. /data/games/saves/heroic/into_the_breach
rsync -r "/data/games/heroic/prefixes/default/Hob/drive_c/users/${USER}/Documents/My Games/Runic Games/Hob/SAVES"/. /data/games/saves/heroic/hob
rsync -r "/data/games/heroic/prefixes/default/Torchlight II/drive_c/users/${USER}/Documents/My Games/Runic Games/Torchlight 2/save"/. /data/games/saves/heroic/torchlight_ii
EOF

chmod +x ${HOME}/.local/bin/backup-heroic-saves.sh

# Create backups systemd service
tee ${HOME}/.config/systemd/user/backup-heroic-saves.path << EOF
[Unit]
Description="Monitor the Heroic save directories for changes"

[Path]
PathChanged=/data/games/heroic/prefixes/default/Remnant From the Ashes/drive_c/users/${USER}/AppData/Local/Remnant/Saved/SaveGames
PathChanged=/data/games/heroic/prefixes/default/The Pathless/drive_c/users/${USER}/AppData/Local/Pathless/Saved/SaveGames
PathChanged=/data/games/heroic/prefixes/default/Solar Ash/drive_c/users/${USER}/AppData/Local/Solar/EGS/619ea35adadd4d6cb8fea37060af796c/SaveGames
PathChanged=/data/games/heroic/prefixes/default/Wonder Boy The Dragons Trap/drive_c/users/${USER}/AppData/Local/Lizardcube/The Dragon's Trap
PathChanged=/data/games/heroic/prefixes/default/Shadow Tactics Blades of the Shogun/drive_c/users/${USER}/AppData/Local/Daedalic Entertainment GmbH/Shadow Tactics Blades of the Shogun Aikos Choice/user
PathChanged=/data/games/heroic/prefixes/default/Scourgebringer/drive_c/users/${USER}/AppData/LocalLow/Flying Oak Games/ScourgeBringer
PathChanged=/data/games/heroic/prefixes/default/Void Bastards/drive_c/users/${USER}/AppData/LocalLow/BlueManchu/VoidBastards
PathChanged=/data/games/heroic/prefixes/default/Cris Tales/drive_c/users/${USER}/AppData/LocalLow/Dreams Uncorpored LLC/Cristales
PathChanged=/data/games/heroic/prefixes/default/Dandara Trials of Fear Edition/drive_c/users/${USER}/AppData/LocalLow/Long Hat House/Dandara
PathChanged=/data/games/heroic/prefixes/default/Sable/drive_c/users/${USER}/AppData/LocalLow/Shedworks/Sable
PathChanged=/data/games/heroic/prefixes/default/Hell is Others/drive_c/users/${USER}/AppData/LocalLow/Strelka Games/Hell Is Others/EGS/619ea35adadd4d6cb8fea37060af796c/Saves
PathChanged=/data/games/heroic/prefixes/default/Into The Breach/drive_c/users/${USER}/Documents/My Games/Into The Breach
PathChanged=/data/games/heroic/prefixes/default/Hob/drive_c/users/${USER}/Documents/My Games/Runic Games/Hob/SAVES
PathChanged=/data/games/heroic/prefixes/default/Torchlight II/drive_c/users/${USER}/Documents/My Games/Runic Games/Torchlight 2/save
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