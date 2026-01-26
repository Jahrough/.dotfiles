#!/usr/bin/env bash
# =============================================================================
# core/fzf.sh
# Interactive fuzzy search helpers using fzf
# Fully DRY_RUN aware, cross-platform, integrates with run()/run_or_dry()
# =============================================================================

set -euo pipefail

: "${DOTFILES_ROOT:?DOTFILES_ROOT must be set}"

# Source core libraries
source "DOTFILES_CORE/run.sh"
source "DOTFILES_CORE/log.sh"
source "DOTFILES_CORE/secrets.sh"

# -----------------------------------------------------------------------------
# Generic fzf selector
# -----------------------------------------------------------------------------
# Arguments:
#   $1 = prompt string
#   $2..n = options
# Returns:
#   selected option
# -----------------------------------------------------------------------------
run_fzf() {
    local prompt="$1"
    shift
    local options=("$@")
    local selected

    if [ "${DRY_RUN:-false}" = true ]; then
        log "[DRY-RUN] run_fzf would show options: ${options[*]}"
        return 0
    fi

    selected=$(printf "%s\n" "${options[@]}" | fzf --prompt="$prompt > ")
    echo "$selected"
}

# -----------------------------------------------------------------------------
# Select a Taskfile module to run
# -----------------------------------------------------------------------------
select_task_module() {
    local module_dir="${DOTFILES_ROOT}/modules"
    local modules
    mapfile -t modules < <(find "$module_dir" -name "*.yml" | sort)

    local selected
    selected=$(run_fzf "Select Taskfile module" "${modules[@]}")
    if [ -n "$selected" ]; then
        run "Running Taskfile module $selected" task -f "$selected"
    fi
}

# -----------------------------------------------------------------------------
# Select a script to run
# -----------------------------------------------------------------------------
select_script() {
    local scripts
    mapfile -t scripts < <(find "$DOTFILES_ROOT" -type f -name "*.sh" | sort)

    local selected
    selected=$(run_fzf "Select script" "${scripts[@]}")
    if [ -n "$selected" ]; then
        run "Running $selected" bash "$selected"
    fi
}

# -----------------------------------------------------------------------------
# Edit configuration interactively
# -----------------------------------------------------------------------------
edit_config() {
    local configs
    mapfile -t configs < <(find "$DOTFILES_ROOT/config" -type f | sort)

    local selected
    selected=$(run_fzf "Select config to edit" "${configs[@]}")
    if [ -n "$selected" ]; then
        run "Opening $selected" "${EDITOR:-nvim}" "$selected"
    fi
}

# -----------------------------------------------------------------------------
# Interactive cleanup selection
# -----------------------------------------------------------------------------
select_cleanup() {
    local dirs=("$XDG_CACHE_HOME" "$XDG_STATE_HOME/logs" "$HOME/.npm" "$HOME/.local/share/pnpm")
    local selected
    selected=$(run_fzf "Select directories to clean (multi-select allowed)" "${dirs[@]}" --multi)
    
    if [ -n "$selected" ]; then
        for dir in $selected; do
            run "Cleaning $dir" rm -rf "$dir"
        done
    fi
}

# -----------------------------------------------------------------------------
# Interactive secrets selection
# -----------------------------------------------------------------------------
select_secret() {
    local secret_files
    mapfile -t secret_files < <(find "$DOTFILES_ROOT/secrets" -name "*.age" | sort)

    local selected
    selected=$(run_fzf "Select secret to decrypt" "${secret_files[@]}")
    if [ -n "$selected" ]; then
        local value
        value=$(decrypt_secret "$selected")  # From core/secrets.sh
        echo "$value"
    fi
}

# -----------------------------------------------------------------------------
# Helpers to list modules/scripts/configs/secrets
# Can be used in DRY_RUN mode
# -----------------------------------------------------------------------------
list_task_modules() {
    find "${DOTFILES_ROOT}/modules" -name "*.yml" | sort
}

list_scripts() {
    find "$DOTFILES_ROOT" -type f -name "*.sh" | sort
}

list_configs() {
    find "$DOTFILES_ROOT/config" -type f | sort
}

list_secrets() {
    find "$DOTFILES_ROOT/secrets" -name "*.age" | sort
}
