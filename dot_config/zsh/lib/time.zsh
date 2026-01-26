# =============================================================================
# lib/time.zsh — time utilities
# =============================================================================

timestamp() {
  date +"%Y%m%d_%H%M%S"
}

epoch() {
  date +%s
}

elapsed() {
  local start="$1"
  require_arg "$start" elapsed || return 1
  echo "$(( $(epoch) - start ))"
}
