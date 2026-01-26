#!/usr/bin/env bash
# =============================================================================
# core/run.sh
# -----------------------------------------------------------------------------
# Central command runner for dotfiles/bootstrap system
# Provides:
#   - run(): DRY_RUN-aware command execution with logging
#   - run_retry(): retries command N times with delay
#   - run_spinner(): executes long-running commands with live spinner
# -----------------------------------------------------------------------------
# Requirements:
#   - DOTFILES_ROOT must be set
#   - log() and log_error() functions available (from core/log.sh)
# -----------------------------------------------------------------------------

set -euo pipefail

: "${DOTFILES_ROOT:?DOTFILES_ROOT must be set}"

# -----------------------------------------------------------------------------
# Source logging library
# -----------------------------------------------------------------------------
source "$DOTFILES_ROOT/lib/core/log.sh"

# -----------------------------------------------------------------------------
# Defaults
# -----------------------------------------------------------------------------
: "${DRY_RUN:=false}"       # Do not execute commands when true
: "${VERBOSE:=true}"        # Print success messages
: "${DOTFILES_LOG:=$HOME/.local/state/dotfiles-setup.log}"

mkdir -p "$(dirname "$DOTFILES_LOG")"


# -----------------------------------------------------------------------------
# run
# -----------------------------------------------------------------------------
# Purpose:
#   Execute a shell command with:
#     - Live output to console and log
#     - Correct exit code capture (even when piping to tee)
#     - DRY_RUN support for safe simulation
#     - Optional verbose success messages
#
# Arguments:
#   $1 = description of the command (human-readable)
#   $2..$n = command + arguments to run
#
# Environment Variables:
#   DRY_RUN    - If true, command is logged but not executed
#   VERBOSE    - If true, logs success messages
#   DOTFILES_LOG - Path to the log file
#
# Usage:
#   run "Install fzf" brew install fzf
# -----------------------------------------------------------------------------
run() {
    # Human-readable description of the action
    local desc="$1"; shift

    # Command as array to handle spaces/special characters
    local cmd=("$@")

    # Log what is about to be executed
    log "→ $desc: ${cmd[*]}"

    # Dry-run mode: do not execute commands, just log intent
    if [ "${DRY_RUN:-false}" = true ]; then
        log "[DRY-RUN] ${cmd[*]}"
        return 0
    fi

    # Execute the command
    # Pipe both stdout and stderr to tee for live output and logging
    "${cmd[@]}" 2>&1 | tee -a "$DOTFILES_LOG"

    # Capture the exit code of the actual command (not tee)
    local rc=${PIPESTATUS[0]}

    # Error handling
    if [ "$rc" -ne 0 ]; then
        log_error "❌ $desc failed (exit code $rc)"
        return "$rc"
    fi

    # Success handling
    # Log success if verbose mode is enabled
    [ "${VERBOSE:-true}" = true ] && log "✅ $desc successful"

    return 0
}


# -----------------------------------------------------------------------------
# run_retry
# Executes a command with retry logic, DRY_RUN aware
# Arguments:
#   $1 -> attempts (default: 3)
#   $2 -> delay in seconds between retries (default: 5)
#   $3 -> description
#   $4..$n -> command and arguments
# -----------------------------------------------------------------------------
run_retry() {
    local attempts="${1:-3}"; shift
    local delay="${1:-5}"; shift
    local desc="$1"; shift
    local cmd=("$@")

    local attempt=1
    while [ "$attempt" -le "$attempts" ]; do
        # Add attempt info to description for logging
        local attempt_desc="$desc (attempt $attempt/$attempts)"

        if run "$attempt_desc" "${cmd[@]}"; then
            return 0
        else
            log_warn "⚠️ $attempt_desc failed. Waiting $delay s before retry..."
            [ "${DRY_RUN:-false}" = false ] && sleep "$delay"
            attempt=$((attempt+1))
        fi
    done

    log_error "❌ $desc failed after $attempts attempts"
    return 1
}


# -----------------------------------------------------------------------------
# run_spinner
# Executes a long-running command with a spinner/UX
# Arguments:
#   $1 -> description
#   $2..$n -> command and args
# Behavior:
#   - DRY_RUN aware: logs but does not execute
#   - Captures stdout/stderr to DOTFILES_LOG
#   - Provides live spinner UX
# -----------------------------------------------------------------------------
run_spinner() {
    local desc="$1"; shift
    local cmd=("$@")
    local pid rc
    local spinstr='|/-\'
    local delay=0.1
    local i=0

    log "⏳ $desc..."

    # Dry-run support
    if [ "${DRY_RUN:-false}" = true ]; then
        log "[DRY-RUN] ${cmd[*]}"
        return 0
    fi

    # Start command in background and capture PID
    "${cmd[@]}" >>"$DOTFILES_LOG" 2>&1 &
    pid=$!

    # Spinner loop
    while kill -0 "$pid" 2>/dev/null; do
        printf "\r⏳ %s %c" "$desc" "${spinstr:$i:1}"
        i=$(( (i + 1) % 4 ))
        sleep "$delay"
    done

    # Wait for command to finish and capture exit code
    wait "$pid"
    rc=$?
    printf "\r"

    if [ "$rc" -eq 0 ]; then
        [ "${VERBOSE:-true}" = true ] && log "✅ $desc successful"
    else
        log_error "❌ $desc failed (exit code $rc). See $DOTFILES_LOG for details"
    fi

    return "$rc"
}
