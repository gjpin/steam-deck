#!/usr/bin/bash

# Source logging functions
source lib/logging.sh

log_start

################################################
##### Base configurations
################################################

log_info "Starting base configurations"
# Base
for module in modules/10-base/*.sh; do
  if [ -f "$module" ]; then
    log_info "Running base module: $module"
    if bash "$module"; then
      log_success "Completed $module"
    else
      log_error "Failed $module"
      exit 1
    fi
  fi
done
log_success "base configurations completed"

################################################
##### Applications
################################################

log_info "Starting applications configurations"
# Applications
for module in modules/20-applications/*.sh; do
  if [ -f "$module" ]; then
    log_info "Running applications module: $module"
    if bash "$module"; then
      log_success "Completed $module"
    else
      log_error "Failed $module"
      exit 1
    fi
  fi
done
log_success "Applications configurations completed"

################################################
##### Emulation
################################################

log_info "Starting emulation configurations"
# Emulation
for module in modules/30-emulation/*.sh; do
  if [ -f "$module" ]; then
    log_info "Running emulation module: $module"
    if bash "$module"; then
      log_success "Completed $module"
    else
      log_error "Failed $module"
      exit 1
    fi
  fi
done
log_success "Emulation configurations completed"

################################################
##### Desktop environment specific configurations
################################################

# Install and configure desktop environment
if [[ "$XDG_CURRENT_DESKTOP" == *"KDE"* ]]; then
  log_info "Detected KDE/Plasma desktop environment, starting Plasma configurations"
  for module in modules/40-plasma/*.sh; do
    if [ -f "$module" ]; then
      log_info "Running Plasma module: $module"
      if bash "$module"; then
        log_success "Completed $module"
      else
        log_error "Failed $module"
        exit 1
      fi
    fi
  done
  log_success "Plasma configurations completed"
else
  log_info "No supported desktop environment detected (XDG_CURRENT_DESKTOP: $XDG_CURRENT_DESKTOP), skipping desktop-specific modules"
fi

log_end