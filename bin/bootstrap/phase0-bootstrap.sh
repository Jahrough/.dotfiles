#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'
umask 022

# =============================================================================
# Phase 0 – Secure Dotfiles Bootstrap
# Purpose:
#   - Establish trusted execution baseline
#   - Install minimal prerequisites (brew + task)
#   - Clone dotfiles repository
#   - Hand off to Task (Phase 1)
#
# Security Guarantees:
#   - macOS only
#   - Minimal privileges
#   - Defensive checks
#   - Explicit failure modes
# =============================================================================

# ---- Readonly Constants ------------------------------------------------------
readonly DOTFILES_ROOT="${DOTFILES_ROOT:-$HOME/.dotfiles}"
readonly DOTFILES_REPO="https://github.com/Jahrough/.dotfiles.git"
readonly REQUIRED_CMDS=(bash curl git uname)

# ---- Logging ----------------------------------------------------------------
log()  { printf "🔹 %s\n" "$*"; }
warn() { printf "⚠️  %s\n" "$*" >&2; }
die()  { printf "❌ %s\n" "$*" >&2; exit 1; }

# ---- Trap for unexpected failures -------------------------------------------
trap 'die "Bootstrap failed at line $LINENO"' ERR

# ---- Environment Validation -------------------------------------------------
OS="$(uname -s)"
[[ "$OS" == "Darwin" ]] || die "Phase 0 supports macOS only (detected: $OS)"

for cmd in "${REQUIRED_CMDS[@]}"; do
  command -v "$cmd" >/dev/null 2>&1 || die "Required command not found: $cmd"
done

# ---- Network Check -----------------------------------------------------------
if ! curl -fsSL --head https://github.com >/dev/null; then
  die "Network access to github.com is required"
fi

# ---- Xcode Command Line Tools ------------------------------------------------
if ! xcode-select -p >/dev/null 2>&1; then
  log "Installing Xcode Command Line Tools..."
  xcode-select --install || true

  log "Waiting for Xcode Command Line Tools installation..."
  until xcode-select -p >/dev/null 2>&1; do
    sleep 5
  done
fi

# ---- Homebrew Installation --------------------------------------------------
if ! command -v brew >/dev/null 2>&1; then
  log "Installing Homebrew (non-interactive)..."
  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# ---- Ensure brew is available in this shell ---------------------------------
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
else
  die "Homebrew binary not found after installation"
fi

command -v brew >/dev/null 2>&1 || die "brew command unavailable"

# ---- Install go-task ---------------------------------------------------------
if ! command -v task >/dev/null 2>&1; then
  log "Installing go-task..."
  brew install go-task/tap/go-task
fi

command -v task >/dev/null 2>&1 || die "task installation failed"

# ---- Clone Dotfiles Repository ----------------------------------------------
if [[ ! -d "$DOTFILES_ROOT" ]]; then
  log "Cloning dotfiles repository into $DOTFILES_ROOT"
  git clone --depth=1 "$DOTFILES_REPO" "$DOTFILES_ROOT"
else
  warn "Dotfiles directory already exists: $DOTFILES_ROOT"
fi

cd "$DOTFILES_ROOT"

# ---- Validate Repository -----------------------------------------------------
[[ -f Taskfile.yml ]] || die "Taskfile.yml not found in dotfiles root"

if ! task -l >/dev/null 2>&1; then
  die "Taskfile exists but failed validation"
fi

# ---- Handoff to Phase 1 ------------------------------------------------------
log "Phase 0 complete. Handing off to Phase 1 (task init)..."
exec task init
