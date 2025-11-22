#!/usr/bin/bash
# Source logging functions
source lib/logging.sh

log_start

# Set Firefox profile path
export FIREFOX_PROFILE_PATH=$(find ${HOME}/.var/app/org.mozilla.firefox/.mozilla/firefox -type d -name "*.default-release")

# Plasma specific configs
cat ./configs/firefox/plasma.js >> ${FIREFOX_PROFILE_PATH}/user.js

tee -a ${HOME}/.local/share/flatpak/overrides/org.mozilla.firefox << EOF

[Environment]
GTK_THEME=Breeze
EOF

log_success "Module completed successfully"
log_end
