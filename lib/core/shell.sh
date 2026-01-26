#!/usr/bin/env bash

setup_shell_integration() {
    local shells=(
        "$HOME/.zshrc"
        "$HOME/.bashrc"
        "$HOME/.config/fish/config.fish"
    )

    local marker="### XDG & mise init ###"

    read -r -d '' block <<'EOF'

### XDG & mise init ###
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export PATH="$HOME/.local/bin:$XDG_CONFIG_HOME/bin:$PATH"

if command -v mise >/dev/null 2>&1; then
    eval "$(mise shell-init)"
fi
### END XDG & mise init ###
EOF

    for rc in "${shells[@]}"; do
        [ -f "$rc" ] || continue

        if ! grep -qF "$marker" "$rc"; then
            [ "$DRY_RUN" = true ] && log "[DRY-RUN] Would update $rc" && continue
            echo "$block" >> "$rc"
            log "✅ Updated $rc"
        else
            log "ℹ️ $rc already configured"
        fi
    done
}
