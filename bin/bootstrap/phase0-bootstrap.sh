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
#   - Verify installer via Cosign
#   - Hand off to Phase 1 (Task workflows)
# =============================================================================

# ---- Readonly Constants ------------------------------------------------------
readonly DOTFILES_ROOT="${DOTFILES_ROOT:-$HOME/.dotfiles}"
readonly DOTFILES_REPO="https://github.com/Jahrough/.dotfiles.git"
readonly INSTALLER_URL="https://raw.githubusercontent.com/Jahrough/.dotfiles/main/install.sh"
readonly COSIGN_CERT_IDENTITY="https://github.com/Jahrough"
readonly COSIGN_OIDC_ISSUER="https://token.actions.githubusercontent.com"
readonly REQUIRED_CMDS=(bash curl git uname)

# -----------------------------------------------------------------------------
# Terminal Capability & Colors
# -----------------------------------------------------------------------------

# Detect if stdout is a TTY
readonly IS_TTY=$([[ -t 1 ]] && echo 1 || echo 0)

# Enable colors only when supported
if [[ $IS_TTY -eq 1 ]] && command -v tput &>/dev/null; then
  C_RESET="$(tput sgr0)"
  C_RED="$(tput setaf 1)"
  C_GREEN="$(tput setaf 2)"
  C_YELLOW="$(tput setaf 3)"
  C_BLUE="$(tput setaf 4)"
else
  C_RESET='' C_RED='' C_GREEN='' C_YELLOW='' C_BLUE=''
fi

# -----------------------------------------------------------------------------
# Logging Helpers
# -----------------------------------------------------------------------------

# Timestamp formatter
_timestamp() { date +"%Y-%m-%d %H:%M:%S"; }

# Append to internal operations log
_log() { OPERATIONS_LOG+=("$1: $2"); }

# Informational log
log() {
  [[ "$LOG_LEVEL" =~ ^(INFO|DEBUG)$ ]] || return
  printf "%s🔹 [INFO  %s]%s %s\n" "$C_BLUE" "$(_timestamp)" "$C_RESET" "$*"
  _log INFO "$*"
}

# Success log
success() {
  printf "%s✅ [OK    %s]%s %s\n" "$C_GREEN" "$(_timestamp)" "$C_RESET" "$*"
  _log OK "$*"
}

# Warning log (stderr)
warn() {
  printf "%s⚠️  [WARN  %s]%s %s\n" "$C_YELLOW" "$(_timestamp)" "$C_RESET" "$*" >&2
}

# Error log (stderr)
error() {
  printf "%s❌ [ERROR %s]%s %s\n" "$C_RED" "$(_timestamp)" "$C_RESET" "$*" >&2
}

# Fatal error helper
die() {
  local code="$1"; shift
  error "$*"
  exit "$code"
}

# ---- Trap for unexpected failures -------------------------------------------
trap 'die "Bootstrap failed at line $LINENO"' ERR

# ---- Environment Validation -------------------------------------------------
OS="$(uname -s)"
[[ "$OS" == "Darwin" ]] || die "Phase 0 supports macOS only (detected: $OS)"

for cmd in "${REQUIRED_CMDS[@]}"; do
  command -v "$cmd" >/dev/null 2>&1 || die "Required command not found: $cmd"
done
success "Environment validation passed (macOS + required commands)"

# ---- Network Check -----------------------------------------------------------
if ! curl -fsSL --head https://github.com >/dev/null; then
  die "Network access to github.com is required"
fi
success "Network connectivity verified"

# ---- Xcode Command Line Tools ------------------------------------------------
if ! xcode-select -p >/dev/null 2>&1; then
  log "Installing Xcode Command Line Tools..."
  xcode-select --install || true

  log "Waiting for Xcode Command Line Tools installation..."
  until xcode-select -p >/dev/null 2>&1; do
    sleep 5
  done
fi
success "Xcode Command Line Tools installed"

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
success "Homebrew installed and available"

# ---- Cosign Verification ----------------------------------------------------
if ! command -v cosign >/dev/null 2>&1; then
  log "Installing cosign..."
  brew install sigstore/tap/cosign
fi
success "Cosign available"

log "Downloading installer for verification..."
curl -fsSL "$INSTALLER_URL" -o install.sh

log "Verifying installer signature with Cosign..."
cosign verify-blob install.sh \
  --certificate-identity "$COSIGN_CERT_IDENTITY" \
  --certificate-oidc-issuer "$COSIGN_OIDC_ISSUER" \
  || die "Cosign verification failed! Aborting bootstrap."

success "Installer verified via Cosign"

# ---- Install go-task ---------------------------------------------------------
if ! command -v task >/dev/null 2>&1; then
  log "Installing go-task..."
  brew install go-task/tap/go-task
fi

command -v task >/dev/null 2>&1 || die "task installation failed"
success "go-task installed"

# ---- Clone Dotfiles Repository ----------------------------------------------
if [[ ! -d "$DOTFILES_ROOT" ]]; then
  log "Cloning dotfiles repository into $DOTFILES_ROOT"
  git clone --depth=1 "$DOTFILES_REPO" "$DOTFILES_ROOT"
  success "Dotfiles repository cloned"
else
  warn "Dotfiles directory already exists: $DOTFILES_ROOT"
fi

cd "$DOTFILES_ROOT"

# ---- Validate Repository -----------------------------------------------------
[[ -f Taskfile.yml ]] || die "Taskfile.yml not found in dotfiles root"

if ! task -l >/dev/null 2>&1; then
  die "Taskfile exists but failed validation"
fi
success "Dotfiles repository validated"

# ---- Handoff to Phase 1 ------------------------------------------------------
success "Phase 0 complete. Handing off to Phase 1 (task init)…"
exec task init
