#!/usr/bin/env bash
set -euo pipefail

linux_preflight() {
    local deps
    if command -v apt >/dev/null 2>&1; then
        deps=(build-essential git)
        for dep in "${deps[@]}"; do
            if ! dpkg -s "$dep" >/dev/null 2>&1; then
                log_error "$dep not installed. Please install manually: sudo apt install $dep"
            else
                log "✅ $dep found"
            fi
        done
    elif command -v dnf >/dev/null 2>&1; then
        deps=(gcc make git)
        for dep in "${deps[@]}"; do
            if ! rpm -q "$dep" >/dev/null 2>&1; then
                log_error "$dep not installed. Please install manually: sudo dnf install $dep"
            else
                log "✅ $dep found"
            fi
        done
    elif command -v pacman >/dev/null 2>&1; then
        deps=(base-devel git)
        for dep in "${deps[@]}"; do
            if ! pacman -Qi "$dep" >/dev/null 2>&1; then
                log_error "$dep not installed. Please install manually: sudo pacman -S $dep"
            else
                log "✅ $dep found"
            fi
        done
    elif command -v zypper >/dev/null 2>&1; then
        deps=(gcc make git)
        for dep in "${deps[@]}"; do
            if ! rpm -q "$dep" >/dev/null 2>&1; then
                log_error "$dep not installed. Please install manually: sudo zypper install $dep"
            else
                log "✅ $dep found"
            fi
        done
    else
        log "⚠️ Unknown Linux distro. Ensure required packages are installed."
    fi
}
