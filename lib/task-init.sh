#!/usr/bin/env bash
set -euo pipefail

source "$DOTFILES_ROOT/lib/log.sh"
source "$DOTFILES_ROOT/lib/run_cmd.sh"

run_task_init() {
    if ! command -v task >/dev/null 2>&1; then
        log_error "Task CLI not installed. Please install it first."
        return 1
    fi

    log "🚀 Running Taskfile init..."
    if [ "$DRY_RUN" = true ]; then
        log "[DRY-RUN] Would run: task init"
        return 0
    fi

    local output
    if output=$(task init 2>&1); then
        log "✅ Taskfile initialization completed successfully"
    else
        log_error "❌ Taskfile initialization failed. Output:\n$output"
        return 1
    fi
}
