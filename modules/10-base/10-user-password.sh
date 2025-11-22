#!/usr/bin/bash
# Source logging functions
source lib/logging.sh

log_start

# Check password status (P = password set, L = locked, NP = no password)
PASS_STATUS=$(passwd -S 2>/dev/null | awk '{print $2}')

if [[ "${PASS_STATUS}" != "P" ]]; then
    log_info "User password not set (status: ${PASS_STATUS}). Setting password..."
    passwd
    log_success "Password set successfully"
else
    log_info "User password already set, skipping..."
fi

log_success "Module installed successfully"
log_end