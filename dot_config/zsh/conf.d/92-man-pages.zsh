# =============================================================================
# conf.d/90-man.zsh — MAN pages environment configuration
# =============================================================================

# -----------------------------------------------------------------------------
# Use bat for pretty-man pages
# -----------------------------------------------------------------------------
if command -v bat >/dev/null 2>&1; then
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
else
    # fallback to default pager
    export MANPAGER="${MANPAGER:-less}"
fi

# -----------------------------------------------------------------------------
# Preserve formatting for roff
# -----------------------------------------------------------------------------
export MANROFFOPT="-c"

# =============================================================================
# conf.d/90-man.zsh — Colored man pages
# =============================================================================
# Enables ANSI colors in man pages via less.
# Safe for interactive shells only.

[[ -o interactive ]] || return

# Less color definitions
export LESS_TERMCAP_mb=$'\e[1;31m'    # begin blinking
export LESS_TERMCAP_md=$'\e[1;36m'    # begin bold
export LESS_TERMCAP_me=$'\e[0m'       # reset bold/blink
export LESS_TERMCAP_so=$'\e[01;44;33m' # begin standout
export LESS_TERMCAP_se=$'\e[0m'       # reset standout
export LESS_TERMCAP_us=$'\e[1;32m'    # begin underline
export LESS_TERMCAP_ue=$'\e[0m'       # reset underline
