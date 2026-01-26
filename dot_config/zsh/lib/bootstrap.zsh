# =============================================================================
# ~/.config/zsh/lib/bootstrap.zsh — Modular Zsh bootstrap
# -----------------------------------------------------------------------------
# Responsibilities:
# - Load core helpers (path, xdg, validation, etc.)
# - Set minimal environment and XDG directories
# - Load interactive shell configuration (conf.d)
# - Load language/runtime modules (languages)
# - Load local overrides (optional)
# - Provide optional tracing for startup order
# =============================================================================

# -----------------------------------------------------------------------------
# Tracing (optional)
# -----------------------------------------------------------------------------
# Set TRACE_STARTUP=1 to visualize sourcing order
[[ -n "${TRACE_STARTUP:-}" ]] && trace() { print -P "%F{cyan}[trace]%f $1"; } || trace() { :; }

# -----------------------------------------------------------------------------
# Ensure ZDOTDIR is set
# -----------------------------------------------------------------------------
: "${ZDOTDIR:?ZDOTDIR must be set}"
trace "ZDOTDIR=$ZDOTDIR"

# -----------------------------------------------------------------------------
# Load core helpers
# -----------------------------------------------------------------------------
local helper="$ZDOTDIR/lib/helpers.zsh"
if [[ -r "$helper" ]]; then
    trace "Sourcing helpers: $helper"
    source "$helper"
else
    print -u2 "Warning: helpers not found: $helper"
fi

# -----------------------------------------------------------------------------
# XDG base directories (minimal environment)
# -----------------------------------------------------------------------------
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

trace "XDG dirs: config=$XDG_CONFIG_HOME data=$XDG_DATA_HOME cache=$XDG_CACHE_HOME state=$XDG_STATE_HOME"

# -----------------------------------------------------------------------------
# Minimal PATH for non-interactive shells
# -----------------------------------------------------------------------------
export PATH="/usr/bin:/bin:/usr/sbin:/sbin"
trace "PATH initialized: $PATH"

# -----------------------------------------------------------------------------
# Load conf.d fragments (interactive shell only)
# -----------------------------------------------------------------------------
if [[ -o interactive ]] && [[ -d "$ZDOTDIR/conf.d" ]]; then
    trace "Loading conf.d fragments..."
    for file in "$ZDOTDIR/conf.d"/*.zsh; do
        [[ -r "$file" ]] && { trace "Sourcing conf.d: $file"; source "$file"; }
    done
fi

# -----------------------------------------------------------------------------
# Load language/runtime modules
# -----------------------------------------------------------------------------
if [[ -o interactive ]] && [[ -d "$ZDOTDIR/languages" ]]; then
    trace "Loading languages modules..."
    for lang_file in "$ZDOTDIR/languages"/*.zsh; do
        [[ -r "$lang_file" ]] && { trace "Sourcing language: $lang_file"; source "$lang_file"; }
    done
fi

# -----------------------------------------------------------------------------
# Machine/user overrides (interactive shell)
# -----------------------------------------------------------------------------
local local_rc="$ZDOTDIR/.zshrc.local"
if [[ -o interactive ]] && [[ -r "$local_rc" ]]; then
    trace "Loading local overrides: $local_rc"
    source "$local_rc"
fi

# -----------------------------------------------------------------------------
# End of bootstrap
# -----------------------------------------------------------------------------
trace "Zsh bootstrap complete"
