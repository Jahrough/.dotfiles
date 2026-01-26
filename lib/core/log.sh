#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# log.sh - Idempotent logging utilities with levels
# -----------------------------------------------------------------------------
# Features:
# - log       : info messages
# - log_warn  : warning messages
# - log_error : error messages
# - log_debug : debug messages (only if VERBOSE=true)
# - run: executes commands, respects DRY_RUN mode
# - Supports DRY_RUN awareness for bootstrap scripts
# - Logs both to console (with colors) and to persistent log file
# -----------------------------------------------------------------------------

# Prevent multiple sourcing
[ -n "${__LOG_SH:-}" ] && return
__LOG_SH=1

# -----------------------------------------------------------------------------
# Configuration
# -----------------------------------------------------------------------------
: "${DOTFILES_ROOT:?DOTFILES_ROOT must be set before sourcing log.sh}"  # Must be set
: "${VERBOSE:=true}"   # Controls whether messages are printed to console
: "${DRY_RUN:=false}"  # Controls whether commands are executed or only logged

# Source helper for running commands safely (if needed)
source "$DOTFILES_ROOT/lib/run_cmd.sh"

# Log directory and file (XDG-compliant location)
readonly LOG_DIR="$HOME/.local/state/init/logs"
mkdir -p "$LOG_DIR" || {
    echo "❌ Failed to create log directory $LOG_DIR" >&2
    return 1
}
readonly LOG_FILE="$LOG_DIR/init.log"

# -----------------------------------------------------------------------------
# Helpers
# -----------------------------------------------------------------------------

# Returns timestamp in YYYY-MM-DD HH:MM:SS format
timestamp() { date +"%Y-%m-%d %H:%M:%S"; }

# Internal logging function
# Arguments:
#   $1 = level icon (💡, ⚠️, ❌, 🐛)
#   $2 = color code for console output
#   $@ = message text
_log_msg() {
    local level="$1"
    local color="$2"
    shift 2
    local ts
    ts=$(timestamp)

    # Console output with optional color (only if VERBOSE)
    if [ "$VERBOSE" = true ]; then
        if [ -n "$color" ]; then
            printf "[$ts] %b %s%b\n" "$color" "$level $*" "\033[0m"
        else
            echo "[$ts] $level $*"
        fi
    fi

    # Always append to log file (plain text, no color)
    echo "[$ts] $level $*" >> "$LOG_FILE"
}

# -----------------------------------------------------------------------------
# Public logging functions
# -----------------------------------------------------------------------------

# Info / general messages
log() {
    _log_msg "💡" "" "$@"
}

# Warnings
log_warn() {
    _log_msg "⚠️" "\033[1;33m" "$@"
}

# Errors
log_error() {
    _log_msg "❌" "\033[1;31m" "$@"
}

# Debug messages (only shown when VERBOSE=true)
log_debug() {
    [ "$VERBOSE" = true ] || return 0
    _log_msg "🐛" "\033[1;36m" "$@"
}

