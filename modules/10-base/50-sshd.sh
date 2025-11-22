#!/usr/bin/bash
# Source logging functions
source lib/logging.sh

log_start

log_info "Configuring SSHD..."

# Check if SSHD is already running
if systemctl is-enabled --quiet sshd 2>/dev/null; then
    log_info "SSHD service is already enabled, skipping."
    exit 0
fi

sudo tee /etc/ssh/sshd_config << EOF
Port 22
PermitRootLogin no
AuthorizedKeysFile      .ssh/authorized_keys
PasswordAuthentication no
PermitEmptyPasswords no
UsePAM yes
PrintMotd no
Subsystem       sftp    /usr/lib/ssh/sftp-server
EOF

sudo systemctl enable --now sshd.service

log_success "Module installed successfully"
log_end