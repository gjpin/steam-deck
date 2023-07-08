################################################
##### Restore Heroic saves from Syncthing to Desktop
################################################

# Create restore script
tee ${HOME}/.local/bin/restore-heroic-saves.sh << EOF
#!/usr/bin/bash
rsync -r --mkpath "/data/games/saves/heroic/remnant_from_the_ashes/" "/data/games/heroic/prefixes/default/Remnant From the Ashes/drive_c/users/${USER}/AppData/Local/Remnant/Saved/SaveGames"


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