#!/usr/bin/bash
# Source logging functions
source lib/logging.sh

log_start

# Install GTK themes
sudo flatpak install -y flathub org.gtk.Gtk3theme.Breeze org.gtk.Gtk3theme.adw-gtk3 org.gtk.Gtk3theme.adw-gtk3-dark

log_success "Module completed successfully"
log_end
