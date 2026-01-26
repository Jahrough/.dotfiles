# =============================================================================
# conf.d/10-editor.zsh — Interactive editor and pager
# =============================================================================

[[ -o interactive ]] || return

# -----------------------------------------------------------------------------
# EDITOR / VISUAL
# -----------------------------------------------------------------------------
if command -v nvim >/dev/null 2>&1; then
    export EDITOR='nvim' VISUAL='nvim'
elif command -v vim >/dev/null 2>&1; then
    export EDITOR='vim' VISUAL='vim'
elif command -v vi >/dev/null 2>&1; then
    export EDITOR='vi' VISUAL='vi'
else
    export EDITOR='nano' VISUAL='nano'
fi

# -----------------------------------------------------------------------------
# PAGER / LESS
# -----------------------------------------------------------------------------
if command -v less >/dev/null 2>&1; then
    export PAGER='less'
    export LESS='-R -F -X -i -M -W -q'
    export LESSHISTFILE="$XDG_STATE_HOME/less/history"
    export LESSCHARSET='utf-8'
else
    export PAGER='more'
fi
