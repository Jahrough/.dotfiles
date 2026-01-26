# =============================================================================
# ~/.config/zsh/conf.d/00-exports.zsh — Interactive environment variables
# -----------------------------------------------------------------------------
# Responsibilities:
# - Set XDG-compliant directories
# - Configure locale and language
# - Add user and package manager paths
# - Set application/tool configuration directories
# - Configure shell history
# - Load optional local overrides
# =============================================================================


# -----------------------------------------------------------------------------
# Application & Tool config directories
# -----------------------------------------------------------------------------
# XDG-compliant configuration directories for specific interactive tools.
export RANGER_CONFIG_DIR="$XDG_CONFIG_HOME/ranger"     # Ranger file manager
export MC_CONFIG_DIR="$XDG_CONFIG_HOME/mc"             # Midnight Commander config
export MC_DATADIR="$XDG_DATA_HOME/mc"                  # Midnight Commander data dir
export BTOP_CONFIG_DIR="$XDG_CONFIG_HOME/btop"         # Btop system monitor
export HTOPRC="$XDG_CONFIG_HOME/htop/htoprc"           # Htop config file
export NCDU_CONFIG="$XDG_CONFIG_HOME/ncdu/config"      # Ncdu config file



# -----------------------------------------------------------------------------
# Python Directories (XDG-compliant)
# -----------------------------------------------------------------------------
export PYTHONUSERBASE="${XDG_DATA_HOME}/python"
export PYTHON_HISTORY="${XDG_STATE_HOME}/python/history"
export PYTHONSTARTUP="${XDG_CONFIG_HOME}/python/pythonrc"

# Python Package Managers
export PIP_CACHE_DIR="${XDG_CACHE_HOME}/pip"
export PIP_CONFIG_FILE="${XDG_CONFIG_HOME}/pip/pip.conf"
export PIPENV_CACHE_DIR="${XDG_CACHE_HOME}/pipenv"
export PIPX_CACHE_DIR="${XDG_CACHE_HOME}/pipx"
export PIPX_HOME="${XDG_DATA_HOME}/pipx"
export WORKON_HOME="${XDG_DATA_HOME}/virtualenvs"

# Python Tools
export PYLINTHOME="${XDG_CACHE_HOME}/pylint"
export PYLINTRC="${XDG_CONFIG_HOME}/pylint/pylintrc"
export IPYTHONDIR="${XDG_CONFIG_HOME}/ipython"
export JUPYTER_CONFIG_DIR="${XDG_CONFIG_HOME}/jupyter"

# Python Behavior
export PYTHONDONTWRITEBYTECODE=1
export PYTHONUNBUFFERED=1
export PYTHONPYCACHEPREFIX="${XDG_CACHE_HOME}/python"

xdg_mkdirs \
  "$PYTHONUSERBASE" \
  "$XDG_STATE_HOME/python" \
  "$XDG_CONFIG_HOME/python" \
  "$XDG_CACHE_HOME/python" \
  "$XDG_CACHE_HOME/pip" \
  "$XDG_CONFIG_HOME/pip" \
  "$IPYTHONDIR" \
  "$JUPYTER_CONFIG_DIR"


# -----------------------------------------------------------------------------
# Go
# -----------------------------------------------------------------------------
export GOPATH="${XDG_DATA_HOME}/go"
export GOMODCACHE="${XDG_CACHE_HOME}/go/mod"
export GOCACHE="${XDG_CACHE_HOME}/go/build"
export GO111MODULE=on
export GOPROXY="https://proxy.golang.org,direct"

# -----------------------------------------------------------------------------
# Haskell
# -----------------------------------------------------------------------------
export STACK_ROOT="${XDG_DATA_HOME}/stack"
export CABAL_CONFIG="${XDG_CONFIG_HOME}/cabal/config"
export CABAL_DIR="${XDG_DATA_HOME}/cabal"


# -----------------------------------------------------------------------------
# Java / Gradle
# -----------------------------------------------------------------------------
export GRADLE_USER_HOME="${XDG_DATA_HOME}/gradle"
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=${XDG_CONFIG_HOME}/java"


# -----------------------------------------------------------------------------
# Node.js / npm / nvm / yarn / pnpm (XDG + nvm-safe)
# -----------------------------------------------------------------------------
export NODE_REPL_HISTORY="${XDG_STATE_HOME}/node_repl_history"
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"
export NPM_CONFIG_CACHE="${XDG_CACHE_HOME}/npm"
export NVM_DIR="${XDG_DATA_HOME}/nvm"
export YARN_CACHE_FOLDER="${XDG_CACHE_HOME}/yarn"
export YARN_CONFIG_DIR="${XDG_CONFIG_HOME}/yarn"
export YARN_GLOBAL_FOLDER="${XDG_DATA_HOME}/yarn"
export PNPM_HOME="${XDG_DATA_HOME}/pnpm"
export NODE_OPTIONS="--max-old-space-size=4096"

# -----------------------------------------------------------------------------
# Rust / Cargo XDG-compliant setup
# -----------------------------------------------------------------------------
# XDG directories
export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export RUSTUP_HOME="${XDG_DATA_HOME}/rustup"


# -----------------------------------------------------------------------------
# Ruby / Gems / Bundler XDG-compliant setup
# -----------------------------------------------------------------------------
# XDG directories
export GEMRC="${XDG_CONFIG_HOME}/gem/gemrc"
export GEM_HOME="${XDG_DATA_HOME}/gem"
export GEM_SPEC_CACHE="${XDG_CACHE_HOME}/gem"

export BUNDLE_USER_CONFIG="${XDG_CONFIG_HOME}/bundle"
export BUNDLE_USER_CACHE="${XDG_CACHE_HOME}/bundle"
export BUNDLE_USER_PLUGIN="${XDG_DATA_HOME}/bundle"

# -----------------------------------------------------------------------------
# VIM# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# Add to ~/.zshrc or ~/.bashrc
export VIMINIT='source $HOME/.config/vim/vimrc'



# -----------------------------------------------------------------------------
# Load local overrides (optional)
# -----------------------------------------------------------------------------
# Allows machine-specific or user overrides without modifying the main config.
# Fails silently if the file does not exist.
[[ -f "$ZDOTDIR/.zshrc.local" ]] && source "$ZDOTDIR/.zshrc.local" 2>/dev/null || true
