#!/usr/bin/env bash
set -euo pipefail
# -e  : exit immediately on error
# -u  : treat unset variables as errors
# -o pipefail : fail pipelines if any command fails

# -----------------------------------------------------------------------------
# Dependency Installation (Functional Style)
# -----------------------------------------------------------------------------
# Purpose:
#   - Ensure required CLI tools are installed for the dotfiles bootstrap
#   - Uses Homebrew as the package manager
#   - Designed to be safe to re-run (idempotent)
#   - Supports DRY_RUN mode for safe auditing
#
# Assumptions:
#   - Homebrew is already installed and initialized in the environment
#   - Logging helpers (log, log_error) are already sourced
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Dependencies
# -----------------------------------------------------------------------------
# Requires:
# - DOTFILES_ROOT to be set by the caller (bin/init.sh)
# - lib/log.sh
# - lib/run.sh
# -----------------------------------------------------------------------------

source "$DOTFILES_ROOT/lib/log.sh"
source "$DOTFILES_ROOT/lib/run.sh"

# -----------------------------------------------------------------------------
# Configuration
# -----------------------------------------------------------------------------

# List of core dependencies required by the dotfiles workflow.
# Add new tools here to automatically include them in installation.
readonly DEPENDENCIES=(
    chezmoi   # Dotfiles manager
    task      # Taskfile task runner
    jq        # Lightweight JSON processor
)

# -----------------------------------------------------------------------------
# Predicates (pure)
# -----------------------------------------------------------------------------

# Check whether a command exists on PATH.
# This function is "pure":
#   - No side effects
#   - Output depends only on input
# Returns:
#   0 if the command exists
#   1 otherwise
is_installed() {
    command -v "$1" >/dev/null 2>&1
}

# -----------------------------------------------------------------------------
# Side-effect helpers
# -----------------------------------------------------------------------------

# Execute a command or log intent when DRY_RUN=true.
#
# Arguments:
#   $1 - Human-readable description of the action
#   $@ - Command to execute
#
# Behavior:
#   - In DRY_RUN mode, logs the command without executing it
#   - Captures stdout/stderr to prevent silent failures
#   - Logs success or failure consistently
run() {
    local description="$1"
    shift

    # Dry-run mode: log intent only, do not execute
    if [ "${DRY_RUN:-false}" = true ]; then
        log "[DRY-RUN] Would run: $*"
        return 0
    fi

    # Execute command and capture output and exit code
    local output rc
    output=$("$@" 2>&1) || rc=$?
    rc=${rc:-0}

    # Handle failure explicitly to surface errors
    if [ "$rc" -ne 0 ]; then
        log_error "❌ $description failed. Output:\n$output"
        return "$rc"
    fi

    # Log success if command completed successfully
    log "✅ $description successful"
}

# -----------------------------------------------------------------------------
# Actions
# -----------------------------------------------------------------------------

# Install a single dependency using Homebrew.
#
# Behavior:
#   - Skips installation if the dependency is already present
#   - Logs progress and result
#   - Delegates execution to run for DRY_RUN support
install_dependency() {
    local dep="$1"

    # Skip already-installed dependencies
    if is_installed "$dep"; then
        log "✅ $dep already installed"
        return 0
    fi

    # Install missing dependency
    log "📦 Installing $dep..."
    run "Install $dep" brew install "$dep"
}

# Install all dependencies defined in DEPENDENCIES.
#
# This is the public entry point for this module.
# Safe to call multiple times.
install_dependencies() {
    log "🔧 Installing dependencies..."

    # Iterate through each dependency and install if missing
    for dep in "${DEPENDENCIES[@]}"; do
        install_dependency "$dep"
    done

    log "✅ Dependency installation complete"
}
