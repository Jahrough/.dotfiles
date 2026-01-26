# =============================================================================
# lib/exec.zsh — execution helpers
# =============================================================================

has_cmd() {
  command -v "$1" >/dev/null 2>&1
}

first_cmd() {
  local cmd
  for cmd in "$@"; do
    has_cmd "$cmd" && { print -r -- "$cmd"; return 0; }
  done
  return 1
}

run_if_exists() {
  local cmd="$1"; shift
  has_cmd "$cmd" || return 127
  "$cmd" "$@"
}
