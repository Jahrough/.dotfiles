#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# core/env.sh
# Single source of truth for environment configuration
# Safe to source multiple times
# =============================================================================

# -----------------------------------------------------------------------------
# Execution flags
# -----------------------------------------------------------------------------
: "${DRY_RUN:=false}"
: "${VERBOSE:=true}"

export DRY_RUN VERBOSE

# -----------------------------------------------------------------------------
# XDG Base Directories
# -----------------------------------------------------------------------------
: "${XDG_CONFIG_HOME:=$HOME/.config}"
: "${XDG_DATA_HOME:=$HOME/.local/share}"
: "${XDG_STATE_HOME:=$HOME/.local/state}"
: "${XDG_CACHE_HOME:=$HOME/.cache}"

export XDG_CONFIG_HOME XDG_DATA_HOME XDG_STATE_HOME XDG_CACHE_HOME

# -----------------------------------------------------------------------------
# Dotfiles layout
# -----------------------------------------------------------------------------
: "${DOTFILES_ROOT:=$HOME/Developer/.dotfiles}"
: "${DOTFILES_CORE:=DOTFILES_CORE}"
: "${DOTFILES_BIN:=$DOTFILES_ROOT/bin}"
: "${DOTFILES_CONFIG:=$DOTFILES_ROOT/dot_config}"

export DOTFILES_ROOT DOTFILES_CORE DOTFILES_BIN DOTFILES_CONFIG

# -----------------------------------------------------------------------------
# Machine awareness
# -----------------------------------------------------------------------------
HOSTNAME="$(hostname -s 2>/dev/null || hostname)"
MACHINE_OVERRIDE="$DOTFILES_ROOT/machines/$HOSTNAME"

export HOSTNAME MACHINE_OVERRIDE

# -----------------------------------------------------------------------------
# Logging
# -----------------------------------------------------------------------------
LOG_DIR="$XDG_STATE_HOME/dotfiles"
LOG_FILE="$LOG_DIR/init.log"

export LOG_DIR LOG_FILE

[[ "$DRY_RUN" == true ]] || mkdir -p "$LOG_DIR"
