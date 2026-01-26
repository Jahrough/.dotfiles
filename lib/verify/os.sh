#!/usr/bin/env bash

detect_os() {
    OS="$(uname -s)"
    ARCH="$(uname -m)"
    log "🖥️ OS: $OS"
    log "⚙️ ARCH: $ARCH"
}

macos_preflight() {
    if ! xcode-select -p >/dev/null 2>&1; then
        log_error "Xcode CLI Tools missing"
        xcode-select --install
        exit 0
    fi
}

os_preflight() {
    case "$OS" in
        Darwin) macos_preflight ;;
        Linux) : ;; # extend later
        *) log "⚠️ Unknown OS: $OS" ;;
    esac
}
