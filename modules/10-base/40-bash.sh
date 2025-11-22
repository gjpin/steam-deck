#!/usr/bin/bash
# Source logging functions
source lib/logging.sh

log_start

# Create directory for custom bash entries
log_info "Configuring bash..."

mkdir -p ${HOME}/.bashrc.d

# Only append to .bashrc if $HOME/.local/bin is not in PATH
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    tee -a ${HOME}/.bashrc << 'EOF'

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
        for rc in ~/.bashrc.d/*; do
                if [ -f "$rc" ]; then
                        . "$rc"
                fi
        done
fi

unset rc
EOF
fi

log_success "Module installed successfully"
log_end