# =============================================================================
# lib/detect.zsh — environment & platform detection
# =============================================================================

is_interactive() { [[ $- == *i* ]]; }

is_login_shell() { [[ -o login ]]; }

is_mac() { [[ "$(uname -s 2>/dev/null)" == "Darwin" ]]; }

is_linux() { [[ "$(uname -s 2>/dev/null)" == "Linux" ]]; }

is_wsl() {
  [[ -r /proc/version ]] && grep -qi microsoft /proc/version 2>/dev/null
}

is_tty() { [[ -t 1 ]]; }
