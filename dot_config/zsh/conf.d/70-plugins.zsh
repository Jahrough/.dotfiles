# =============================================================================
# ~/.config/zsh/conf.d/50-plugins.zsh — Plugins & Enhancements
# =============================================================================
# Responsibilities:
# - Load essential plugins safely
# - Support fallback loading
# - Lazy-load to improve shell startup
# - Interactive shell only
# =============================================================================

[[ -o interactive ]] || return 0

# -----------------------------------------------------------------------------
# Base plugin array (always enabled)
# -----------------------------------------------------------------------------
plugins=(git)

# -----------------------------------------------------------------------------
# Helper: Add a plugin if available
# -----------------------------------------------------------------------------
add_plugin() {
    local plugin="$1"
    local cmd_check="$2"  # optional command that must exist
    local plugin_dir="$ZDOTDIR/plugins/$plugin"

    [[ -d "$plugin_dir" ]] || return 0
    [[ -n "$cmd_check" ]] && command -v "$cmd_check" >/dev/null 2>&1 || return 0
    plugins+=("$plugin")
}

# -----------------------------------------------------------------------------
# Reusable fallback loader
# -----------------------------------------------------------------------------
load_plugin_if_missing() {
    local target="$1"; shift
    local file
    # Skip if function or command exists
    if [[ -n "$target" ]] && (typeset -f "$target" >/dev/null 2>&1 || command -v "$target" >/dev/null 2>&1); then
        return 0
    fi
    # Source first existing file
    for file in "$@"; do
        [[ -f "$file" ]] && source "$file" 2>/dev/null && break
    done
}

# -----------------------------------------------------------------------------
# Plugins — Organized by category
# -----------------------------------------------------------------------------

# Enhanced Shell Experience
add_plugin zsh-autosuggestions
add_plugin zsh-syntax-highlighting
add_plugin zsh-completions
add_plugin zsh-history-substring-search
# add_plugin colored-man-pages

# Navigation & Directory Management
add_plugin z
add_plugin fzf

# Terminal & Session Management
add_plugin ssh-agent
add_plugin tmux

# Version Managers & Languages
add_plugin nvm
add_plugin pyenv
add_plugin rvm
add_plugin rbenv
add_plugin jenv
add_plugin scalaenv
add_plugin golang
add_plugin rust
add_plugin php
add_plugin lua

# Build Tools & Package Managers
add_plugin gradle
add_plugin maven
add_plugin brew
add_plugin npm
add_plugin yarn

# Cloud Providers
add_plugin aws
add_plugin azure
add_plugin gcloud
add_plugin heroku
add_plugin digitalocean

# Container & Orchestration
add_plugin docker docker        # plugin + command check
add_plugin docker-compose
add_plugin docker-machine
add_plugin kubectl kubectl
add_plugin kubectx
add_plugin kubens
add_plugin helm
add_plugin minikube

# Infrastructure as Code
add_plugin terraform
add_plugin ansible
add_plugin vagrant

# Apple Silicon / macOS specific
add_plugin macos

# -----------------------------------------------------------------------------
# Load all plugins safely (silent)
# -----------------------------------------------------------------------------
for plugin in "${plugins[@]}"; do
    local plugin_file="$ZDOTDIR/plugins/$plugin/$plugin.plugin.zsh"
    [[ -f "$plugin_file" ]] && source "$plugin_file" 2>/dev/null
done

# -----------------------------------------------------------------------------
# Fallback loading for critical plugins
# -----------------------------------------------------------------------------
# zsh-autosuggestions
load_plugin_if_missing _zsh_autosuggest_start \
    "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh" \
    "/usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh" \
    "${XDG_CONFIG_HOME:-$HOME/.config}/oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

# zsh-completions
load_plugin_if_missing _completions_start \
    "/opt/homebrew/share/zsh-completions" \
    "/usr/local/share/zsh-completions" \
    "${XDG_CONFIG_HOME:-$HOME/.config}/oh-my-zsh/custom/plugins/zsh-completions/src"

# zsh-syntax-highlighting
load_plugin_if_missing _zsh_highlight \
    "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" \
    "/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" \
    "${XDG_CONFIG_HOME:-$HOME/.config}/oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# -----------------------------------------------------------------------------
# Optional: install missing Oh My Zsh plugins
# -----------------------------------------------------------------------------
install_missing_ohmyzsh_plugins() {
    local ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    local essential_plugins=(zsh-autosuggestions zsh-syntax-highlighting zsh-completions)
    [[ -d "$ZSH_CUSTOM/plugins" ]] || mkdir -p "$ZSH_CUSTOM/plugins"

    for plugin in "${essential_plugins[@]}"; do
        local plugin_dir="$ZSH_CUSTOM/plugins/$plugin"
        if [[ ! -d "$plugin_dir" ]]; then
            echo "Installing $plugin..."
            git clone --depth=1 "https://github.com/zsh-users/$plugin.git" "$plugin_dir"
        fi
    done
    echo "Plugin installation complete. Reload shell: exec zsh"
}
