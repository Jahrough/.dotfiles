#!/usr/bin/env bash
# Exit immediately on error (-e), undefined variables (-u),
# and ensure pipelines fail if any command fails (pipefail)
set -euo pipefail

# -----------------------------------------------------------------------------
# Chezmoi Initialization (Functional Style)
# -----------------------------------------------------------------------------
# This module is responsible for:
# - Bootstrapping chezmoi using a dotfiles repository
# - Applying updates when the repo is already initialized
# - Supporting DRY_RUN execution for safe previews
# - Remaining idempotent and safe to re-run
# -----------------------------------------------------------------------------

: "${DOTFILES_ROOT:?DOTFILES_ROOT must be set before sourcing this module}"


# -----------------------------------------------------------------------------
# Dependencies
# -----------------------------------------------------------------------------
# Requires:
# - DOTFILES_ROOT to be set by the caller (bin/init.sh)
# - lib/env.sh
# - lib/log.sh
# - lib/run.sh
# -----------------------------------------------------------------------------

source "$DOTFILES_ROOT/lib/env.sh"
source "$DOTFILES_ROOT/lib/log.sh"
source "$DOTFILES_ROOT/lib/run.sh"


# -----------------------------------------------------------------------------
# Configuration
# -----------------------------------------------------------------------------

# Default chezmoi working directory (XDG-compliant location)
readonly CHEZMOI_DIR="$HOME/.local/share/chezmoi"


# -----------------------------------------------------------------------------
# Predicates (pure functions)
# -----------------------------------------------------------------------------
# These functions:
# - Perform checks only
# - Produce no side effects
# - Communicate results exclusively via exit status
# -----------------------------------------------------------------------------

# Returns 0 if chezmoi is available on PATH, non-zero otherwise
chezmoi_installed() {
    command -v chezmoi >/dev/null 2>&1
}

# Returns 0 if chezmoi has already been initialized
# (i.e., the working directory exists)
chezmoi_initialized() {
    [ -d "$CHEZMOI_DIR" ]
}

# Returns 0 if chezmoi reports unapplied changes
# Suppresses stderr to avoid noise during normal execution
chezmoi_has_changes() {
    chezmoi diff --short 2>/dev/null | grep -q .
}


# -----------------------------------------------------------------------------
# Actions (imperative operations)
# -----------------------------------------------------------------------------
# These functions:
# - Perform state transitions
# - Compose side-effect helpers and predicates
# -----------------------------------------------------------------------------

# Ensures chezmoi is installed before continuing
# Fails fast with a clear error message
assert_chezmoi_installed() {
    chezmoi_installed && return 0
    log_error "Chezmoi not installed. Please install it first."
    return 1
}

# Performs first-time chezmoi initialization
# Applies the dotfiles repository immediately
initialize_chezmoi() {
    log "🚀 Initializing chezmoi with repo $DOTFILES_REPO..."
    run "Chezmoi initialization" \
        chezmoi init --apply "$DOTFILES_REPO"
}

# Applies pending chezmoi changes to the system
apply_chezmoi_changes() {
    log "⚡ Unapplied changes detected. Applying..."
    run "Chezmoi apply" chezmoi apply
}

# Synchronizes an already-initialized chezmoi repo
# Applies changes only if diffs are detected
sync_existing_chezmoi() {
    log "🔄 Checking for unapplied chezmoi changes..."

    if chezmoi_has_changes; then
        apply_chezmoi_changes
    else
        log "✅ Chezmoi is already up-to-date"
    fi
}


# -----------------------------------------------------------------------------
# Public API
# -----------------------------------------------------------------------------
# Entry point used by the main bootstrap script
# Orchestrates initialization vs. synchronization
# -----------------------------------------------------------------------------

init_chezmoi() {
    # Hard requirement: chezmoi must be installed
    assert_chezmoi_installed || return 1

    # Branch based on initialization state
    if chezmoi_initialized; then
        sync_existing_chezmoi
    else
        initialize_chezmoi
    fi
}
