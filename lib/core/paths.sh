#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# core/paths.sh
# Unified, safe, machine-aware path resolution
# =============================================================================

source "$DOTFILES_CORE/env.sh"

declare -A PATHS=(
  [root]="$DOTFILES_ROOT"
  [bin]="$DOTFILES_BIN"
  [core]="$DOTFILES_CORE"
  [config]="$DOTFILES_CONFIG"

  [xdg_config]="$XDG_CONFIG_HOME"
  [xdg_data]="$XDG_DATA_HOME"
  [xdg_state]="$XDG_STATE_HOME"
  [xdg_cache]="$XDG_CACHE_HOME"

  # Common modules
  [nvim]="$DOTFILES_CONFIG/nvim"
  [zsh]="$DOTFILES_CONFIG/zsh"
  [tmux]="$DOTFILES_CONFIG/tmux"
  [git]="$DOTFILES_CONFIG/git"
)

# -----------------------------------------------------------------------------
# Load machine overrides
# -----------------------------------------------------------------------------
if [[ -d "$MACHINE_OVERRIDE" ]]; then
  for dir in "$MACHINE_OVERRIDE"/*; do
    [[ -d "$dir" ]] || continue
    key="$(basename "$dir")"
    PATHS["$key"]="$dir"
  done
fi

# -----------------------------------------------------------------------------
# Path resolver
# -----------------------------------------------------------------------------
path() {
  local key="$1"; shift
  local base="${PATHS[$key]:-}"

  if [[ -z "$base" ]]; then
    echo "❌ Unknown path key: $key" >&2
    return 1
  fi

  local full="$base"
  [[ $# -gt 0 ]] && full="$full/$*"

  # Normalize without eval
  realpath -m "$full" 2>/dev/null || echo "$full"
}

# -----------------------------------------------------------------------------
# Optional autocomplete
# -----------------------------------------------------------------------------
path_keys() {
  printf '%s\n' "${!PATHS[@]}" | sort
}
