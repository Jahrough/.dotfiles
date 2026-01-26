# =============================================================================
# git.plugin.zsh — Git enhancements
# =============================================================================
# Silent, instant-prompt safe, interactive only

[[ -o interactive ]] || return 0
command -v git >/dev/null 2>&1 || return 0

# -----------------------------------------------------------------------------
# XDG-compliant Git directories
# -----------------------------------------------------------------------------
export GIT_CONFIG_GLOBAL="${XDG_CONFIG_HOME:-$HOME/.config}/git/config"
export GIT_CONFIG_SYSTEM="/etc/gitconfig"
export GIT_TEMPLATE_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/git/templates"
export GIT_ATTRS_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/git/attributes"
export GIT_IGNORE_GLOBAL="${XDG_CONFIG_HOME:-$HOME/.config}/git/ignore"

# -----------------------------------------------------------------------------
# Git completion (prefer Homebrew)
# -----------------------------------------------------------------------------
for completion in \
  "/opt/homebrew/share/zsh/site-functions/_git" \
  "/usr/local/share/zsh/site-functions/_git" \
  "/usr/share/zsh/site-functions/_git"
do
  if [[ -f "$completion" ]]; then
    fpath=("${completion:h}" $fpath)
    autoload -Uz _git
    break
  fi
done

# -----------------------------------------------------------------------------
# Git prompt helpers (Powerlevel10k / vcs_info compatible)
# -----------------------------------------------------------------------------
autoload -Uz vcs_info

# -----------------------------------------------------------------------------
# Sensible defaults (safe)
# -----------------------------------------------------------------------------
export GIT_PAGER="${PAGER:-less}"
export GIT_TERMINAL_PROMPT=1
