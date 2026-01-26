# =============================================================================
# conf.d/20-paths.zsh — User and package manager PATHs
# =============================================================================

# -----------------------------------------------------------------------------
# PATH additions (user & package managers)
# -----------------------------------------------------------------------------
# Prepend directories to PATH for priority lookup.
# Includes package managers like Homebrew and user-local binaries.
path_prepend "/opt/homebrew/bin" "/opt/homebrew/sbin"  # Apple Silicon Homebrew
path_prepend "/usr/local/bin" "/usr/local/sbin"        # Intel Homebrew / legacy
path_prepend "$HOME/.local/bin" "$XDG_DATA_HOME/bin"   # User-local scripts
export PATH  # Export updated PATH for subshells



# -----------------------------------------------------------------------------
# Homebrew
# -----------------------------------------------------------------------------
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi



# -----------------------------------------------------------------------------
# PYTHON
# -----------------------------------------------------------------------------
export PYENV_ROOT="${XDG_DATA_HOME}/pyenv"
export PYTHONUSERBASE="$XDG_DATA_HOME/python"

[[ -d "$PYENV_ROOT/bin" ]] && path_prepend "$PYENV_ROOT/bin"
[[ -d "$PYENV_ROOT/shims" ]] && path_prepend "$PYENV_ROOT/shims"
[[ -d "$PYTHONUSERBASE/bin" ]] && path_append "$PYTHONUSERBASE/bin"

# -----------------------------------------------------------------------------
# Go
# -----------------------------------------------------------------------------
[[ -d "$GOPATH/bin" ]] && path_append "$GOPATH/bin"


# -----------------------------------------------------------------------------
# JAVA
# -----------------------------------------------------------------------------
# Legacy jenv support
[[ -d "$HOME/.jenv" ]] && path_prepend "$HOME/.jenv/bin" && export JAVA_OPTS="-Xmx2g"

# -----------------------------------------------------------------------------
# LLVM (Homebrew)
# -----------------------------------------------------------------------------
[[ -d /opt/homebrew/opt/llvm/bin ]] && path_prepend "/opt/homebrew/opt/llvm/bin"


# -----------------------------------------------------------------------------
# Rust / Cargo XDG-compliant setup
# -----------------------------------------------------------------------------
# Add Cargo binaries to PATH if the directory exists
[[ -d "$CARGO_HOME/bin" ]] && path_prepend "$CARGO_HOME/bin"

# -----------------------------------------------------------------------------
# Scala / scalaenv (legacy support)
# -----------------------------------------------------------------------------
# Add scalaenv binaries to PATH if the directory exists
[[ -d "$HOME/.scalaenv/bin" ]] && path_prepend "$HOME/.scalaenv/bin"

# -----------------------------------------------------------------------------
# Ruby / Gems / Bundler XDG-compliant setup
# -----------------------------------------------------------------------------
# Legacy Ruby version managers (add to PATH if present)
[[ -d "$HOME/.rbenv/bin" ]] && path_prepend "$HOME/.rbenv/bin"
[[ -d "$HOME/.rvm/bin" ]] && path_append "$HOME/.rvm/bin"

# Add XDG-compliant gem binaries to PATH
path_append "$GEM_HOME/bin"




# -----------------------------------------------------------------------------
# Node.js / npm / nvm / yarn / pnpm (XDG + nvm-safe)
# -----------------------------------------------------------------------------
# PATH (do NOT include npm prefix)
path_append "$PNPM_HOME"


# -----------------------------------------------------------------------------
# Ensure essential directories exist (silent)
# -----------------------------------------------------------------------------
essential_dirs=(
    "$ZDOTDIR" "$XDG_STATE_HOME/zsh" "$ZSH_CACHE_DIR"
    "$XDG_STATE_HOME/less" "$XDG_CONFIG_HOME/git" "$XDG_DATA_HOME/gnupg"
    "$XDG_STATE_HOME/sqlite" "$XDG_STATE_HOME/mysql" "$XDG_STATE_HOME/psql"
    "$XDG_STATE_HOME/redis" "$XDG_STATE_HOME/mongodb" "$XDG_STATE_HOME/cassandra"
    "$XDG_STATE_HOME/python" "$XDG_CONFIG_HOME/python" "$XDG_CACHE_HOME/python" "$XDG_CACHE_HOME/pip"
    "$XDG_CONFIG_HOME/npm" "$XDG_CACHE_HOME/npm"
    "$XDG_CONFIG_HOME/aws" "$XDG_CONFIG_HOME/kube" "$XDG_CACHE_HOME/kube"
)
ensure_dirs "${essential_dirs[@]}"

# Secure sensitive directories
for dir in "$XDG_DATA_HOME/gnupg" "$XDG_CONFIG_HOME/aws" "$XDG_CONFIG_HOME/kube"; do
    [[ -d "$dir" ]] && chmod 700 "$dir" 2>/dev/null || true
done