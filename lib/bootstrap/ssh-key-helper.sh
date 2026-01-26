#!/usr/bin/env bash
set -euo pipefail

SSH_DIR="$HOME/.ssh"
SSH_KEY="$SSH_DIR/${SSH_KEY_NAME:-id_ed25519}"

source "$DOTFILES_ROOT/lib/log.sh"
source "$DOTFILES_ROOT/lib/run_cmd.sh"


ensure_ssh_dir() {
    run_cmd mkdir -p "$SSH_DIR"
    run_cmd chmod 700 "$SSH_DIR"
    log "✅ Ensured ~/.ssh exists with correct permissions"
}

choose_ssh_key() {
    # Prefer default key if exists
    if [ -f "$SSH_KEY" ]; then
        echo "$SSH_KEY"
        return
    fi

    # Otherwise, pick first key
    local keys
    keys=($(find "$SSH_DIR" -maxdepth 1 -type f -name "id_*" ! -name "*.pub"))
    if [ "${#keys[@]}" -gt 0 ]; then
        echo "${keys[0]}"
    else
        echo "$SSH_KEY"  # fallback to default
    fi
}

generate_ssh_key_if_missing() {
    local key="$1"
    if [ ! -f "$key" ]; then
        run_cmd "ssh-keygen -t ed25519 -C '$USER@$(hostname)' -f '$key' -N ''"
        run_cmd "chmod 600 '$key' && chmod 644 '$key.pub'"
        log "✅ SSH key generated at $key"
    else
        log "ℹ️ SSH key already exists: $key"
    fi
}

start_ssh_agent() {
    if [ -z "${SSH_AGENT_PID:-}" ] || ! ps -p "$SSH_AGENT_PID" >/dev/null 2>&1; then
        eval "$(ssh-agent -s)" >/dev/null
        log "✅ SSH agent started"
    else
        log "✅ SSH agent already running"
    fi
}

add_key_to_agent_if_missing() {
    local key="$1"

    # Ensure SSH agent is running
    if [ -z "${SSH_AGENT_PID:-}" ] || ! ps -p "$SSH_AGENT_PID" >/dev/null 2>&1; then
        eval "$(ssh-agent -s)" >/dev/null
        log "✅ SSH agent started"
    fi

    # Get the fingerprint of the key
    local fingerprint
    fingerprint=$(ssh-keygen -lf "$key.pub" | awk '{print $2}')

    # Check if key is already loaded
    if ssh-add -l 2>/dev/null | awk '{print $2}' | grep -qF "$fingerprint"; then
        log "ℹ️ SSH key already loaded in agent"
    else
        run_cmd ssh-add "$key"
        log "✅ SSH key added to agent"
    fi
}

show_ssh_pub() {
    local key="$1"
    echo -e "\n💡 Add this SSH public key to GitHub:\nhttps://github.com/settings/ssh/new\n"
    cat "$key.pub"
}

setup_ssh_key() {
    ensure_ssh_dir
    local key
    key=$(choose_ssh_key)
    generate_ssh_key_if_missing "$key"
    start_ssh_agent
    add_key_to_agent_if_missing "$key"
    show_ssh_pub "$key"
}
