# =============================================================================
# 99-plugins.zsh — Local customizations & plugin management
# =============================================================================
# Responsibilities:
# - Load user customizations
# - Ensure essential Oh My Zsh plugins are installed
# - Interactive shell only
# =============================================================================

# Skip non-interactive shells
[[ -o interactive ]] || return

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
# Usage: call manually
# install_missing_ohmyzsh_plugins
# -----------------------------------------------------------------------------