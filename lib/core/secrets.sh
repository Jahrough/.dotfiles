#!/usr/bin/env bash
# core/secrets.sh

: "${DOTFILES_ROOT:?DOTFILES_ROOT must be set}"
source "DOTFILES_CORE/log.sh"

DRY_RUN=${DRY_RUN:-false}

get_secret() {
    local file="$1"
    if [ "$DRY_RUN" = true ]; then
        log "[DRY-RUN] Would decrypt secret: $file"
        echo "DRY_RUN_SECRET"
        return
    fi
    age --decrypt "$DOTFILES_ROOT/secrets/$file.age"
}

export_secret() {
    local name="$1"
    local file="$2"
    export "$name=$(get_secret "$file")"
    log "✅ Exported secret $name"
}
