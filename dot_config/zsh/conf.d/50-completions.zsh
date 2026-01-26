# =============================================================================
# ZSH COMPLETION SYSTEM (XDG-compliant)
# =============================================================================

# -----------------------------------------------------------------------------
# Cache Setup
# -----------------------------------------------------------------------------
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
export ZSH_COMPDUMP="${ZSH_CACHE_DIR}/.zcompdump"

# Ensure cache directory exists
[[ -d "$ZSH_CACHE_DIR" ]] || mkdir -p "$ZSH_CACHE_DIR"

# -----------------------------------------------------------------------------
# Initialize Completion System (once)
# -----------------------------------------------------------------------------
autoload -Uz compinit
compinit -C -d "$ZSH_COMPDUMP"

# -----------------------------------------------------------------------------
# Completion UI & Behavior
# -----------------------------------------------------------------------------
# Menu selection
zstyle ':completion:*' menu select

# Case-insensitive and partial matching
zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z}={A-Za-z}' \
  'r:|[._-]=* r:|=*' \
  'l:|=* r:|=*'

# Group formatting & descriptions
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '[%d]'

# Approximate completion
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Cache usage
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$ZSH_CACHE_DIR"

# Colorized listings
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"

# -----------------------------------------------------------------------------
# Tool-Specific Completions (Safe & Optional)
# -----------------------------------------------------------------------------
command -v kubectl >/dev/null 2>&1 && source <(kubectl completion zsh) 2>/dev/null
command -v helm    >/dev/null 2>&1 && source <(helm completion zsh) 2>/dev/null
command -v gh      >/dev/null 2>&1 && eval "$(gh completion -s zsh)" 2>/dev/null

# Docker (macOS app path)
if command -v docker >/dev/null 2>&1; then
  local docker_comp="/Applications/Docker.app/Contents/Resources/etc/docker.zsh-completion"
  [[ -f "$docker_comp" ]] && source "$docker_comp"
fi
