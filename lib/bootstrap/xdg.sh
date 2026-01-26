#!/usr/bin/env bash

setup_xdg_dirs() {
    : "${XDG_CONFIG_HOME:=$HOME/.config}"
    : "${XDG_DATA_HOME:=$HOME/.local/share}"
    : "${XDG_STATE_HOME:=$HOME/.local/state}"
    : "${XDG_CACHE_HOME:=$HOME/.cache}"

    local dirs=(
        "$XDG_CONFIG_HOME"
        "$XDG_DATA_HOME"
        "$XDG_STATE_HOME"
        "$XDG_CACHE_HOME"
        "$HOME/.local/bin"
    )

    for dir in "${dirs[@]}"; do
        if [ ! -d "$dir" ]; then
            mkdir -p "$dir" && log "✅ Created $dir"
        else
            log "ℹ️ $dir already exists"
        fi
    done
}
