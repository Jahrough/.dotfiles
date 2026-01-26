# =============================================================================
# 90-terminal.zsh — Terminal multiplexers & navigation
# =============================================================================
# Responsibilities:
# - TMUX, Zellij, Screen
# - Fast navigation (zoxide)
# - Terminal emulator configs (Alacritty, Kitty, WezTerm, Warp, Hyper)
# - XDG-compliant paths
# - Lazy-load to improve shell startup
# - Skip initialization in CI / non-interactive shells / SSH
# =============================================================================


# -----------------------------------------------------------------------------
# Cleanup temporary/internal variables
# -----------------------------------------------------------------------------
unset TPM_PATH

# -----------------------------------------------------------------------------
# Safe plugin installer for Oh My Zsh (idempotent)
# -----------------------------------------------------------------------------
install_missing_ohmyzsh_plugins() {
    local ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    local plugins=("zsh-autosuggestions" "zsh-syntax-highlighting" "zsh-completions")
    
    [[ -d "$ZSH_CUSTOM/plugins" ]] || mkdir -p "$ZSH_CUSTOM/plugins"

    for plugin in "${plugins[@]}"; do
        local plugin_dir="$ZSH_CUSTOM/plugins/$plugin"
        if [[ ! -d "$plugin_dir" ]]; then
            echo "Installing $plugin..."
            git clone --depth=1 "https://github.com/zsh-users/$plugin.git" "$plugin_dir"
        fi
    done
    echo "Plugin installation complete. Reload shell with: exec zsh"
}


# -----------------------------------------------------------------------------
# Zoxide — Fast directory navigation (lazy-load)
# -----------------------------------------------------------------------------
if command -v zoxide >/dev/null 2>&1; then
    export _ZO_DATA_DIR="${XDG_DATA_HOME}/zoxide"
    autoload -Uz add-zoxide-hook >/dev/null 2>&1  # optional helper
    eval "$(zoxide init zsh)"
fi


# -----------------------------------------------------------------------------
# Terminal emulator config paths
# -----------------------------------------------------------------------------
export ALACRITTY_CONFIG="${XDG_CONFIG_HOME}/alacritty/alacritty.yml"
export KITTY_CONFIG_DIRECTORY="${XDG_CONFIG_HOME}/kitty"
export WEZTERM_CONFIG_FILE="${XDG_CONFIG_HOME}/wezterm/wezterm.lua"
export WARP_CONFIG_DIR="${XDG_CONFIG_HOME}/warp"
export HYPER_CONFIG="${XDG_CONFIG_HOME}/hyper/hyper.js"
export VSCODE_EXTENSIONS="${XDG_DATA_HOME}/vscode/extensions"
export SUBLIME_CONFIG_PATH="${XDG_CONFIG_HOME}/sublime-text"


# -----------------------------------------------------------------------------
# Skip initialization in CI or non-interactive SSH/shell scripts
# -----------------------------------------------------------------------------
if [[ -n "$CI" ]] || { [[ -n "$SSH_CONNECTION" ]] && ! -t 0; }; then
    return
fi

# -----------------------------------------------------------------------------
# TMUX
# -----------------------------------------------------------------------------
export TMUX_CONFIG="${XDG_CONFIG_HOME}/tmux/tmux.conf"
export TMUX_PLUGIN_MANAGER_PATH="${XDG_DATA_HOME}/tmux/plugins"

# Note: TPM scripts should be loaded in ~/.tmux.conf, not here

# -----------------------------------------------------------------------------
# Zellij
# -----------------------------------------------------------------------------
export ZELLIJ_CONFIG_DIR="${XDG_CONFIG_HOME}/zellij"
export ZELLIJ_CACHE_DIR="${XDG_CACHE_HOME}/zellij"

# -----------------------------------------------------------------------------
# GNU Screen
# -----------------------------------------------------------------------------
export SCREENRC="${XDG_CONFIG_HOME}/screen/screenrc"