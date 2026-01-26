# =============================================================================
# lib/helpers.zsh — public helper facade
# =============================================================================

[[ -n "${_ZSH_HELPERS_LOADED:-}" ]] && return
typeset -g _ZSH_HELPERS_LOADED=1

: "${ZDOTDIR:?ZDOTDIR must be set}"
typeset -g _LIBDIR="${ZDOTDIR}/lib"

__helpers_source() {
    local file="$1"
    if [[ -r "$file" ]]; then
        source "$file"
    else
        print -u2 "helpers.zsh: missing helper module: $file"
        return 1
    fi
}

__helpers_source "$_LIBDIR/detect.zsh"
__helpers_source "$_LIBDIR/exec.zsh"
__helpers_source "$_LIBDIR/time.zsh"
__helpers_source "$_LIBDIR/paths.zsh"
__helpers_source "$_LIBDIR/validate.zsh"
__helpers_source "$_LIBDIR/xdg.zsh"

unset -f __helpers_source
unset _LIBDIR
