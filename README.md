# Quickstart
1. Update SteamOS and reboot
2. Run setup.sh
3. Copy SSH private/public key to $HOME/.ssh
   * Private key: `chmod 600 $HOME/.ssh/id_ecdsa`
   * Public key: `chmod 644 $HOME/.ssh/id_ecdsa.pub`
4. Copy wireguard key to /etc/wireguard and enable connection: `sudo nmcli con import type wireguard file /etc/wireguard/wg0.conf`
5. Configure Heroic:
   * Login to GoG / Epic
   * Wine Manager -> Download latest GE Proton (specific version, not "latest")
   * Settings -> General -> Set folder for new wine prefix: $HOME/Games/Heroic/Prefixes
   * Settings -> General -> Automatically update games
   * Settings -> General -> Add games to Steam automatically
   * Settings -> Game Defaults -> WinePrefix folder: $HOME/Games/Heroic/Prefixes
   * Settings -> Game Defaults -> Wine Version -> specific Proton GE version (eg. 10-25)
   * Add Heroic to Steam (Steam -> Add a Game -> Heroic)
6. In Steam Game Mode:
   * Install Decky Loader plugins
      * SteamGridDB
7. Configure RetroDeck:
   * Open RetroDeck and go through setup
   * Add RetroDeck to Steam (Steam -> Add a Game -> RetroDeck)
   * Open RetroDeck through gamemode and configure:
      * Set Steam Input profile
      * UI settings -> theme -> Slate
      * Scraper -> Account settings -> Screenscraper username/password
8. Add 3 folders to Syncthing:
   * saves-heroic: $HOME/Games/saves-heroic
   * saves-steam: $HOME/Games/saves-steam
   * saves-retrodeck: $HOME/Games/Emulation/retrodeck/saves
   * saves-emulation: $HOME/Games/Emulation/saves
9. Reboot