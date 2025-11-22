#!/usr/bin/bash
# Source logging functions
source lib/logging.sh

log_start

# Set Plasma theme
kwriteconfig6 --file kdeglobals --group KDE --key LookAndFeelPackage "org.kde.breezedark.desktop"

# Enable 2 desktops
kwriteconfig6 --file kwinrc --group Desktops --key Name_2 "Desktop 2"
kwriteconfig6 --file kwinrc --group Desktops --key Number "2"
kwriteconfig6 --file kwinrc --group Desktops --key Rows "1"

# Change window decorations
kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key ButtonsOnLeft ""
kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key ButtonsOnRight "IAX"
kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key ShowToolTips --type bool false

# Disable app launch feedback
kwriteconfig6 --file klaunchrc --group BusyCursorSettings --key "Bouncing" --type bool false
kwriteconfig6 --file klaunchrc --group FeedbackStyle --key "BusyCursor" --type bool false

# Disable cursor shake
kwriteconfig6 --file kwinrc --group Plugins --key "shakecursorEnabled" --type bool false

# Disable windows outline
kwriteconfig6 --file breezerc --group "Common" --key OutlineIntensity "OutlineOff"

log_success "Module completed successfully"
log_end
