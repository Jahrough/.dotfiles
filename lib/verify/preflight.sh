#!/usr/bin/env bash

check_command() {
    command -v "$1" >/dev/null 2>&1
}

preflight_checks() {
    local missing=false
    for cmd in "$@"; do
        if ! check_command "$cmd"; then
            log_error "$cmd missing"
            missing=true
        else
            log "✅ $cmd found"
        fi
    done

    $missing && exit 1
}
