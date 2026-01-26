# =============================================================================
# ~/.config/zsh/lib/paths.zsh — PATH & filesystem helpers
# -----------------------------------------------------------------------------
# Responsibilities:
# - Safe PATH manipulation (prepend, append, remove)
# - Directory creation utilities (ensure_dirs)
# - Pure functions where possible
# =============================================================================

# -----------------------------------------------------------------------------
# PATH Helpers
# -----------------------------------------------------------------------------

# Check if a directory is already in PATH
path_contains() {
    [[ ":$PATH:" == *":$1:"* ]]
}

# Prepend directories to PATH if they exist and are not already in PATH
path_prepend() {
  for dir in "$@"; do
    [[ -d "$dir" ]] || continue
    path_contains "$dir" && continue
    PATH="$dir:$PATH"
  done
}
  for dir in "$@"; do
    [[ -d "$dir" && ":$PATH:" != *":$dir:"* ]] && PATH="$dir:$PATH"
  done
# Append directories to PATH if they exist and are not already in PATH
path_append() {
  for dir in "$@"; do
    [[ -d "$dir" ]] || continue
    path_contains "$dir" && continue
    PATH="$PATH:$dir"
  done
}

# Remove a directory from PATH
path_remove() {
  [[ -z "$1" ]] && return
  PATH=$(echo "$PATH" | awk -v RS=: -v ORS=: '$0 != "'"$1"'"' | sed 's/:$//')
}

# Add directory to PATH and export
path_add() {
    [[ -d "$1" ]] || return 1
    [[ ":$PATH:" == *":$1:"* ]] || export PATH="$1:$PATH"
}

# -----------------------------------------------------------------------------
# Directory Helpers
# -----------------------------------------------------------------------------

# Ensure directories exist; create if missing
ensure_dirs() {
  for dir in "$@"; do
    [[ -d "$dir" ]] || mkdir -p "$dir" 2>/dev/null
  done
}

# -----------------------------------------------------------------------------
# Self-tests (run when DEBUG_PATHS=1)
# -----------------------------------------------------------------------------
if [[ -n "${DEBUG_PATHS:-}" ]]; then
    echo "[paths.zsh] Running self-tests..."

    # Save original PATH
    local _PATH_ORIG="$PATH"

    # Test path_prepend
    PATH="/tmp/test1:/tmp/test2"
    mkdir -p /tmp/test3
    path_prepend /tmp/test3
    [[ "$PATH" == "/tmp/test3:/tmp/test1:/tmp/test2" ]] || print -u2 "path_prepend failed"

    # Test path_append
    PATH="/tmp/test1:/tmp/test2"
    path_append /tmp/test3
    [[ "$PATH" == "/tmp/test1:/tmp/test2:/tmp/test3" ]] || print -u2 "path_append failed"

    # Test path_remove
    PATH="/tmp/test1:/tmp/test2:/tmp/test3"
    path_remove /tmp/test2
    [[ "$PATH" == "/tmp/test1:/tmp/test3" ]] || print -u2 "path_remove failed"

    # Test ensure_dirs
    ensure_dirs /tmp/test4 /tmp/test5
    [[ -d /tmp/test4 && -d /tmp/test5 ]] || print -u2 "ensure_dirs failed"

    # Cleanup
    PATH="$_PATH_ORIG"
    rm -rf /tmp/test3 /tmp/test4 /tmp/test5

    echo "[paths.zsh] Self-tests complete"
fi
