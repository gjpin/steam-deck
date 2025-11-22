# Quickstart
1. Update SteamOS and reboot
2. Run setup.sh
3. Copy SSH public key to $HOME/.ssh/authorized_keys
4. Copy wireguard key to /etc/wireguard and enable connection: `sudo nmcli con import type wireguard file /etc/wireguard/wg0.conf`
5. Configure Heroic:
   * Login to GoG / Epic
   * General -> Set folder for new wine prefix: $HOME/Games/Heroic/Prefixes
   * General -> Automatically update games
   * General -> Add games to Steam automatically
   * Game Defaults -> WinePrefix folder: $HOME/Games/Heroic/Prefixes
   * Add Heroic to Steam (Steam -> Add a Game -> Heroic)
6. In Steam Game Mode:
   * Install Decky Loader plugins
      * SteamGridDB
      * HLTB for Deck
   * (HTPC only) Settings -> Display -> Maximum game resolution -> 3840x2160
7. Configure RetroDeck:
   * Open RetroDeck and go through setup
   * Add RetroDeck to Steam (Steam -> Add a Game -> RetroDeck)
   * Open RetroDeck through gamemode and configure:
      * UI settings -> theme -> Slate
      * Scraper -> Account settings -> Screenscraper username/password

8. Reboot