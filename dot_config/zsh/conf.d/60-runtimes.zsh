#!/usr/bin/env zsh
# =============================================================================
# XDG-COMPLIANT RUNTIME MANAGER
# =============================================================================
# Features:
# - XDG Base Directory compliance
# - Unified initialization
# - Lazy loading for faster startup
# - Auto-disable on CI/SSH
# - Mise as primary runtime manager (fallbacks)
# - Direnv for project-local auto-switching
# =============================================================================

# =============================================================================
# Runtime Environment Detection
# =============================================================================
_should_skip_runtimes() {
  [[ -n "$CI" ]] || ([[ -n "$SSH_CONNECTION" ]] && ! [[ -t 0 ]])
}
[[ $(_should_skip_runtimes) -eq 0 ]] && return 0

# =============================================================================
# XDG Paths for Tooling
# =============================================================================
export POETRY_HOME="${XDG_DATA_HOME}/poetry"
export POETRY_CONFIG_DIR="${XDG_CONFIG_HOME}/poetry"
export POETRY_CACHE_DIR="${XDG_CACHE_HOME}/poetry"

export UV_CACHE_DIR="${XDG_CACHE_HOME}/uv"
export UV_CONFIG_FILE="${XDG_CONFIG_HOME}/uv/uv.toml"
export RYE_HOME="${XDG_DATA_HOME}/rye"

export ANDROID_HOME="${XDG_DATA_HOME}/android"
export ANDROID_SDK_ROOT="${XDG_DATA_HOME}/android"
export ANDROID_AVD_HOME="${XDG_DATA_HOME}/android/avd"
export ANDROID_EMULATOR_HOME="${XDG_DATA_HOME}/android/emulator"
export GRADLE_USER_HOME="${XDG_DATA_HOME}/gradle"
export M2_HOME="${XDG_DATA_HOME}/maven"
export MAVEN_OPTS="-Dmaven.repo.local=${XDG_DATA_HOME}/maven/repository"
export SBT_OPTS="-Dsbt.global.base=${XDG_DATA_HOME}/sbt -Dsbt.ivy.home=${XDG_DATA_HOME}/ivy2"

# =============================================================================
# Lazy Initialization Helper
# =============================================================================
_lazy_init_runtime() {
  local name="$1" init_cmd="$2" marker_var="__${name}_loaded"
  [[ -n "${(P)marker_var}" ]] && return 0
  eval "$init_cmd" 2>/dev/null || return 1
  eval "export $marker_var=1"
}

# =============================================================================
# Primary Runtime Manager: MISE
# =============================================================================
if command -v mise >/dev/null 2>&1; then
  export MISE_CONFIG_DIR="$XDG_CONFIG_HOME/mise"
  export MISE_DATA_DIR="$XDG_DATA_HOME/mise"
  export MISE_CACHE_DIR="$XDG_CACHE_HOME/mise"
  export MISE_STATE_DIR="$XDG_STATE_HOME/mise"

  eval "$(mise activate zsh --shims 2>/dev/null)"

  if [[ -f "$MISE_CONFIG_DIR/config.toml" ]] || [[ -f ".mise.toml" ]] || [[ -f ".tool-versions" ]]; then
    return 0
  fi
fi

# =============================================================================
# Direnv - Project-local environment auto-switching
# =============================================================================
if command -v direnv >/dev/null 2>&1; then
  export DIRENV_CONFIG="$XDG_CONFIG_HOME/direnv"
  eval "$(direnv hook zsh 2>/dev/null)"
fi

# =============================================================================
# Python (pyenv) - Lazy Loading
# =============================================================================
if command -v pyenv >/dev/null 2>&1; then
  export PYENV_ROOT="${PYENV_ROOT:-$XDG_DATA_HOME/pyenv}"
  [[ -d "$PYENV_ROOT/shims" ]] && PATH="$PYENV_ROOT/shims:$PATH"

  pyenv() { 
    _lazy_init_runtime "pyenv" 'eval "$(command pyenv init - zsh)"' && command pyenv "$@"; 
  }
  
  python() { 
    _lazy_init_runtime "pyenv" 'eval "$(command pyenv init - zsh)"' && command python "$@"; 
  }

  pip() { 
    _lazy_init_runtime "pyenv" 'eval "$(command pyenv init - zsh)"' && command pip "$@"; 
  }
fi

# =============================================================================
# Ruby (rbenv) - Lazy Loading
# =============================================================================
if command -v rbenv >/dev/null 2>&1; then
  export RBENV_ROOT="${RBENV_ROOT:-$XDG_DATA_HOME/rbenv}"

  rbenv() { _lazy_init_runtime "rbenv" 'eval "$(command rbenv init - zsh)"' && command rbenv "$@"; }
  ruby() { _lazy_init_runtime "rbenv" 'eval "$(command rbenv init - zsh)"' && command ruby "$@"; }
  gem() { _lazy_init_runtime "rbenv" 'eval "$(command rbenv init - zsh)"' && command gem "$@"; }
  bundle() { _lazy_init_runtime "rbenv" 'eval "$(command rbenv init - zsh)"' && command bundle "$@"; }
fi

# =============================================================================
# Node.js (nvm) - Lazy Loading
# =============================================================================
export NVM_DIR="${NVM_DIR:-$XDG_DATA_HOME/nvm}"
_load_nvm() {
  [[ -n "$__nvm_loaded" ]] && return 0
  for nvm_script in "/opt/homebrew/opt/nvm/nvm.sh" "$NVM_DIR/nvm.sh"; do
    [[ -s "$nvm_script" ]] && source "$nvm_script" && break
  done
  __nvm_loaded=1
  nvm use default >/dev/null 2>&1 || nvm use node >/dev/null 2>&1 || true
}
for cmd in nvm node npm npx pnpm yarn; do
  eval "$cmd() { _load_nvm && command $cmd \"\$@\"; }"
done

# =============================================================================
# Java (jenv) - Lazy Loading
# =============================================================================
if command -v jenv >/dev/null 2>&1; then
  export JENV_ROOT="${JENV_ROOT:-$XDG_DATA_HOME/jenv}"
  jenv() { _lazy_init_runtime "jenv" 'eval "$(command jenv init -)"' && command jenv "$@"; }
  java() { _lazy_init_runtime "jenv" 'eval "$(command jenv init -)"' && command java "$@"; }
fi

# =============================================================================
# Scala (scalaenv) - Lazy Loading
# =============================================================================
if command -v scalaenv >/dev/null 2>&1; then
  export SCALAENV_ROOT="${SCALAENV_ROOT:-$XDG_DATA_HOME/scalaenv}"
  scalaenv() { _lazy_init_runtime "scalaenv" 'eval "$(command scalaenv init -)"' && command scalaenv "$@"; }
  scala() { _lazy_init_runtime "scalaenv" 'eval "$(command scalaenv init -)"' && command scala "$@"; }
fi

# =============================================================================
# Rust (cargo) - XDG compliant
# =============================================================================
if [[ -f "${CARGO_HOME:-$XDG_DATA_HOME/cargo}/env" ]]; then
  export CARGO_HOME="${CARGO_HOME:-$XDG_DATA_HOME/cargo}"
  export RUSTUP_HOME="${RUSTUP_HOME:-$XDG_DATA_HOME/rustup}"
  source "$CARGO_HOME/env"
fi

# =============================================================================
# Lua (luarocks) - XDG compliant
# =============================================================================
if command -v luarocks >/dev/null 2>&1; then
  export LUAROCKS_TREE="${XDG_DATA_HOME}/luarocks"
  LUAROCKS_CONFIG_FILE="${XDG_CONFIG_HOME}/luarocks/config.lua"
  [[ -f "$LUAROCKS_CONFIG_FILE" ]] && export LUAROCKS_CONFIG="$LUAROCKS_CONFIG_FILE"
  eval "$(luarocks path 2>/dev/null)" || true
fi

# =============================================================================
# Migration Helpers
# =============================================================================
migrate_to_xdg() {
  local tool="$1"
  case "$tool" in
    pyenv) [[ -d "$HOME/.pyenv" && ! -d "$XDG_DATA_HOME/pyenv" ]] && echo "mv ~/.pyenv $XDG_DATA_HOME/pyenv" ;;
    rbenv) [[ -d "$HOME/.rbenv" && ! -d "$XDG_DATA_HOME/rbenv" ]] && echo "mv ~/.rbenv $XDG_DATA_HOME/rbenv" ;;
    nvm) [[ -d "$HOME/.nvm" && ! -d "$XDG_DATA_HOME/nvm" ]] && echo "mv ~/.nvm $XDG_DATA_HOME/nvm" ;;
    cargo) [[ -d "$HOME/.cargo" && ! -d "$XDG_DATA_HOME/cargo" ]] && echo "mv ~/.cargo $XDG_DATA_HOME/cargo" ;;
    *) echo "Usage: migrate_to_xdg [pyenv|rbenv|nvm|cargo]" ;;
  esac
}

# =============================================================================
# Cleanup
# =============================================================================
unset _should_skip_runtimes
# =============================================================================
# golang.plugin.zsh — Go (Golang) environment
# =============================================================================
# Silent, instant-prompt safe, interactive only

[[ -o interactive ]] || return 0
command -v go >/dev/null 2>&1 || return 0

# -----------------------------------------------------------------------------
# XDG-compliant Go paths
# -----------------------------------------------------------------------------
export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"
export GOCACHE="${XDG_CACHE_HOME:-$HOME/.cache}/go"
export GOMODCACHE="$GOPATH/pkg/mod"

# -----------------------------------------------------------------------------
# Go binaries
# -----------------------------------------------------------------------------
if [[ -d "$GOPATH/bin" ]]; then
  case ":$PATH:" in
    *":$GOPATH/bin:"*) ;;
    *) PATH="$GOPATH/bin:$PATH" ;;
  esac
fi

export PATH

# -----------------------------------------------------------------------------
# Go environment defaults (safe)
# -----------------------------------------------------------------------------
export GO111MODULE=on
export GOPROXY="${GOPROXY:-https://proxy.golang.org,direct}"
export GOSUMDB="${GOSUMDB:-sum.golang.org}"

# -----------------------------------------------------------------------------
# Optional: Go completions (if installed)
# -----------------------------------------------------------------------------
for compdir in \
  "$GOPATH/pkg/mod"/golang.org/x/tools@*/gopls/internal/lsp/source \
  "/opt/homebrew/share/zsh/site-functions" \
  "/usr/local/share/zsh/site-functions"
do
  [[ -d "$compdir" ]] && fpath=("$compdir" $fpath)
done

# -----------------------------------------------------------------------------
# Avoid accidental telemetry / prompts
# -----------------------------------------------------------------------------
export GIT_TERMINAL_PROMPT=1



# =============================================================================
# python.plugin.zsh — Python environment (XDG-compliant)
# =============================================================================
# Responsibilities:
# - Environment variables for Python, pip, pipx, pipenv, virtualenv
# - PATH setup for pyenv and Python user base
# - Essential directories creation (XDG-compliant)
# - Pyenv initialization for login shells
# =============================================================================

[[ -o interactive ]] || return

# -----------------------------------------------------------------------------
# Python Development
# -----------------------------------------------------------------------------
alias py='python3'
alias venv='python3 -m venv'
alias activate='source venv/bin/activate'
alias pipr='pip install -r requirements.txt'
alias pipf='pip freeze > requirements.txt'
alias pipu='pip install --upgrade pip'
alias myserve='python3 -m http.server 8000'
alias myserve8080='python3 -m http.server 8080'



# =============================================================================
# gradle.plugin.zsh — Gradle build tool
# =============================================================================
# Silent, instant-prompt safe, interactive only

[[ -o interactive ]] || return 0
command -v gradle >/dev/null 2>&1 || return 0

# -----------------------------------------------------------------------------
# XDG-compliant Gradle directories
# -----------------------------------------------------------------------------
export GRADLE_USER_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/gradle"

# -----------------------------------------------------------------------------
# Gradle JVM options (safe defaults)
# -----------------------------------------------------------------------------
export GRADLE_OPTS="${GRADLE_OPTS:--Dorg.gradle.daemon=true}"

# -----------------------------------------------------------------------------
# Gradle completion (if available)
# -----------------------------------------------------------------------------
for compdir in \
  "$GRADLE_USER_HOME/completion" \
  "/opt/homebrew/share/zsh/site-functions" \
  "/usr/local/share/zsh/site-functions"
do
  [[ -d "$compdir" ]] && fpath=("$compdir" $fpath)
done

# -----------------------------------------------------------------------------
# Avoid unwanted prompts
# -----------------------------------------------------------------------------
export JAVA_TOOL_OPTIONS="${JAVA_TOOL_OPTIONS:-}"
