#!/usr/bin/bash

# Logging functions for setup scripts
# Provides colored, timestamped logging to stdout

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Log levels
LOG_INFO="INFO"
LOG_WARN="WARN"
LOG_ERROR="ERROR"
LOG_SUCCESS="SUCCESS"

# Log function
# Usage: log <level> <message>
log() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    case "$level" in
        "$LOG_INFO")
            echo -e "${BLUE}[$timestamp] $LOG_INFO: $message${NC}"
            ;;
        "$LOG_WARN")
            echo -e "${YELLOW}[$timestamp] $LOG_WARN: $message${NC}"
            ;;
        "$LOG_ERROR")
            echo -e "${RED}[$timestamp] $LOG_ERROR: $message${NC}" >&2
            ;;
        "$LOG_SUCCESS")
            echo -e "${GREEN}[$timestamp] $LOG_SUCCESS: $message${NC}"
            ;;
        *)
            echo -e "[$timestamp] UNKNOWN: $message"
            ;;
    esac
}

# Convenience functions
log_info() {
    log "$LOG_INFO" "$1"
}

log_warn() {
    log "$LOG_WARN" "$1"
}

log_error() {
    log "$LOG_ERROR" "$1"
}

log_success() {
    log "$LOG_SUCCESS" "$1"
}

# Log start of script
log_start() {
    log_info "Starting $0"
}

# Log end of script
log_end() {
    log_success "Completed $0"
}

# Log command execution (for debugging)
log_cmd() {
    log_info "Executing: $*"
    "$@"
}