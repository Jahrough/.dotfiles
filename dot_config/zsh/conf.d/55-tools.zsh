# =============================================================================
# Shell, Prompt, History
# =============================================================================

# starship
export STARSHIP_CONFIG="${XDG_CONFIG_HOME}/starship/starship.toml"
export STARSHIP_CACHE="${XDG_CACHE_HOME}/starship"

# direnv
export DIRENV_CONFIG="${XDG_CONFIG_HOME}/direnv"

# atuin
export ATUIN_CONFIG_DIR="${XDG_CONFIG_HOME}/atuin"

# -----------------------------------------------------------------------------
# Persistent shell history
# -----------------------------------------------------------------------------
[[ ! -d "$(dirname "$HISTFILE")" ]] && mkdir -p "$(dirname "$HISTFILE")"
export HISTSIZE=10000
export SAVEHIST=10000

# -----------------------------------------------------------------------------
# Sessions
# -----------------------------------------------------------------------------
export ZSH_SESSIONS_DIR="${XDG_STATE_HOME}/zsh/sessions"
[[ ! -d "$ZSH_SESSIONS_DIR" ]] && mkdir -p "$ZSH_SESSIONS_DIR"
export ZSH_SESSION_FILE="$ZSH_SESSIONS_DIR/zsh_sessions"

# =============================================================================
# Language Toolchains & Version Managers
# =============================================================================

# asdf
export ASDF_CONFIG_FILE="${XDG_CONFIG_HOME}/asdf/asdfrc"
export ASDF_DATA_DIR="${XDG_DATA_HOME}/asdf"

# mise
export MISE_CONFIG_DIR="${XDG_CONFIG_HOME}/mise"
export MISE_DATA_DIR="${XDG_DATA_HOME}/mise"
export MISE_CACHE_DIR="${XDG_CACHE_HOME}/mise"

# opam
export OPAMROOT="${XDG_DATA_HOME}/opam"

# racket
export PLTUSERHOME="${XDG_DATA_HOME}/racket"

# deno / bun
export DENO_DIR="${XDG_CACHE_HOME}/deno"
export DENO_INSTALL_ROOT="${XDG_DATA_HOME}/deno"
export BUN_INSTALL="${XDG_DATA_HOME}/bun"

# elixir
export MIX_HOME="${XDG_DATA_HOME}/mix"
export HEX_HOME="${XDG_DATA_HOME}/hex"

# dart / flutter
export DART_SDK="${XDG_DATA_HOME}/dart-sdk"
export FLUTTER_ROOT="${XDG_DATA_HOME}/flutter"
export PUB_CACHE="${XDG_CACHE_HOME}/pub-cache"

# =============================================================================
# Core CLI Utilities
# =============================================================================

export RIPGREP_CONFIG_PATH="${XDG_CONFIG_HOME}/ripgrep/config"
export BAT_CONFIG_PATH="${XDG_CONFIG_HOME}/bat/config"
export BAT_CACHE_PATH="${XDG_CACHE_HOME}/bat"
export FD_OPTIONS="--hidden --follow"
export JQ_COLORS="1;90:0;37:0;37:0;37:0;32:1;37:1;37"
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"
export DELTA_PAGER="less -R"

# =============================================================================
# CLOUD PROVIDERS & DEVOPS TOOLS
# =============================================================================

export AWS_CONFIG_FILE="${XDG_CONFIG_HOME}/aws/config"
export AWS_SHARED_CREDENTIALS_FILE="${XDG_CONFIG_HOME}/aws/credentials"
export AZURE_CONFIG_DIR="${XDG_CONFIG_HOME}/azure"
export CLOUDSDK_CONFIG="${XDG_CONFIG_HOME}/gcloud"
export KUBECONFIG="${XDG_CONFIG_HOME}/kube/config"
export KUBECACHEDIR="${XDG_CACHE_HOME}/kube"
export DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"
export MACHINE_STORAGE_PATH="${XDG_DATA_HOME}/docker-machine"
export TF_CLI_CONFIG_FILE="${XDG_CONFIG_HOME}/terraform/terraformrc"
export TF_PLUGIN_CACHE_DIR="${XDG_CACHE_HOME}/terraform/plugin-cache"
export ANSIBLE_HOME="${XDG_CONFIG_HOME}/ansible"
export ANSIBLE_CONFIG="${XDG_CONFIG_HOME}/ansible/ansible.cfg"
export ANSIBLE_GALAXY_CACHE_DIR="${XDG_CACHE_HOME}/ansible/galaxy_cache"
export ANSIBLE_COLLECTIONS_PATHS="${XDG_DATA_HOME}/ansible/collections"
export ANSIBLE_ROLES_PATH="${XDG_DATA_HOME}/ansible/roles"
export VAGRANT_HOME="${XDG_DATA_HOME}/vagrant"
export VAGRANT_ALIAS_FILE="${XDG_DATA_HOME}/vagrant/aliases"
export HELM_CONFIG_HOME="${XDG_CONFIG_HOME}/helm"
export HELM_CACHE_HOME="${XDG_CACHE_HOME}/helm"
export HELM_DATA_HOME="${XDG_DATA_HOME}/helm"
export MINIKUBE_HOME="${XDG_DATA_HOME}/minikube"
export PACKER_CONFIG_DIR="${XDG_CONFIG_HOME}/packer"
export PACKER_CACHE_DIR="${XDG_CACHE_HOME}/packer"
export NOMAD_CONFIG_DIR="${XDG_CONFIG_HOME}/nomad"
export NOMAD_DATA_DIR="${XDG_DATA_HOME}/nomad"
export VAULT_CONFIG_PATH="${XDG_CONFIG_HOME}/vault"

# =============================================================================
# Databases
# =============================================================================

export SQLITE_HISTORY="${XDG_STATE_HOME}/sqlite/history"
export MYSQL_HISTFILE="${XDG_STATE_HOME}/mysql/history"
export PSQL_HISTORY="${XDG_STATE_HOME}/psql/history"
export REDISCLI_HISTFILE="${XDG_STATE_HOME}/redis/rediscli_history"
export MONGOSH_CONFIG_DIR="${XDG_CONFIG_HOME}/mongosh"
export MONGOSH_HISTORY_FILE="${XDG_STATE_HOME}/mongodb/mongosh_history"
export CQLSH_HISTORY="${XDG_STATE_HOME}/cassandra/cqlsh_history"
export CQLSHRC="${XDG_CONFIG_HOME}/cassandra/cqlshrc"

# =============================================================================
# Version Control
# =============================================================================

export GIT_CONFIG_GLOBAL="${XDG_CONFIG_HOME}/git/config"
export GIT_ATTR_GLOBAL="${XDG_CONFIG_HOME}/git/attributes"
export GIT_IGNORE_GLOBAL="${XDG_CONFIG_HOME}/git/ignore"
export GIT_CREDENTIAL_STORE_FILE="${XDG_CONFIG_HOME}/git/credentials"
export GIT_TEMPLATE_DIR="${XDG_CONFIG_HOME}/git/template"
export GH_CONFIG_DIR="${XDG_CONFIG_HOME}/gh"
export GLAB_CONFIG_DIR="${XDG_CONFIG_HOME}/glab"
export PRE_COMMIT_HOME="${XDG_DATA_HOME}/pre-commit"

# =============================================================================
# Terminals & Editors
# =============================================================================

export ALACRITTY_CONFIG="${XDG_CONFIG_HOME}/alacritty/alacritty.yml"
export KITTY_CONFIG_DIRECTORY="${XDG_CONFIG_HOME}/kitty"
export WEZTERM_CONFIG_FILE="${XDG_CONFIG_HOME}/wezterm/wezterm.lua"
export WARP_CONFIG_DIR="${XDG_CONFIG_HOME}/warp"
export HYPER_CONFIG="${XDG_CONFIG_HOME}/hyper/hyper.js"

export VSCODE_EXTENSIONS="${XDG_DATA_HOME}/vscode/extensions"
export SUBLIME_CONFIG_PATH="${XDG_CONFIG_HOME}/sublime-text"
export CURSOR_CONFIG="${XDG_CONFIG_HOME}/cursor"
export CURSOR_USER_DATA="${XDG_DATA_HOME}/cursor"
export ZED_CONFIG_DIR="${XDG_CONFIG_HOME}/zed"

export MYVIMRC="${XDG_CONFIG_HOME}/vim/vimrc"
export VIM_PLUG_HOME="${XDG_DATA_HOME}/vim/plugged"
export HELIX_RUNTIME="${XDG_DATA_HOME}/helix/runtime"
export KAKRC="${XDG_CONFIG_HOME}/kak/kakrc"
export EMACSDIR="${XDG_CONFIG_HOME}/emacs"

# VS Code CLI
[[ -d "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" ]] && \
  path_append "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# =============================================================================
# JavaScript / Web Tooling
# =============================================================================

export BABEL_CACHE_PATH="${XDG_CACHE_HOME}/babel"
export ESLINT_CONFIG_PATH="${XDG_CONFIG_HOME}/eslint"
export PRETTIER_CONFIG_PATH="${XDG_CONFIG_HOME}/prettier"
export PRETTIERRC="${XDG_CONFIG_HOME}/prettier/.prettierrc"
export TS_NODE_HISTORY="${XDG_STATE_HOME}/ts_node_repl_history"

# =============================================================================
# APIs, Cloud, Infrastructure
# =============================================================================

export HTTPIE_CONFIG_DIR="${XDG_CONFIG_HOME}/httpie"
export POSTMAN_CONFIG_DIR="${XDG_CONFIG_HOME}/Postman"
export INSOMNIA_DATA_PATH="${XDG_DATA_HOME}/insomnia"
export BRUNO_CONFIG_DIR="${XDG_CONFIG_HOME}/bruno"
export NETLIFY_CONFIG_HOME="${XDG_CONFIG_HOME}/netlify"
export VERCEL_CONFIG_DIR="${XDG_CONFIG_HOME}/vercel"
export K9S_CONFIG_DIR="${XDG_CONFIG_HOME}/k9s"

# =============================================================================
# Linting, Prose, File Watching
# =============================================================================

export VALE_CONFIG_PATH="${XDG_CONFIG_HOME}/vale/.vale.ini"
export MARKDOWNLINT_CONFIG="${XDG_CONFIG_HOME}/markdownlint/config.json"
export SHELLCHECK_OPTS="--external-sources"
export WATCHMAN_CONFIG_FILE="${XDG_CONFIG_HOME}/watchman/config.json"
export WATCHMAN_SOCK_DIR="${XDG_RUNTIME_DIR}/watchman"

# =============================================================================
# Git & Dev Dashboards
# =============================================================================

export LG_CONFIG_FILE="${XDG_CONFIG_HOME}/lazygit/config.yml"
export LAZYDOCKER_CONFIG="${XDG_CONFIG_HOME}/lazydocker/config.yml"
export TIGRC_USER="${XDG_CONFIG_HOME}/tig/tigrc"
export GH_DASH_CONFIG="${XDG_CONFIG_HOME}/gh-dash/config.yml"

# =============================================================================
# Task & Time Tracking
# =============================================================================

export TASKRC="${XDG_CONFIG_HOME}/task/taskrc"
export TASKDATA="${XDG_DATA_HOME}/task"
export TIMEWARRIORDB="${XDG_DATA_HOME}/timewarrior"

# =============================================================================
# Build Systems & Compilers
# =============================================================================

export CCACHE_DIR="${XDG_CACHE_HOME}/ccache"
export CTAGS_CONFIG="${XDG_CONFIG_HOME}/ctags/config.ctags"
export GTAGSCONF="${XDG_CONFIG_HOME}/gtags/gtags.conf"
export GTAGSLABEL=pygments
export MESON_BUILD_DIR="${XDG_CACHE_HOME}/meson"
export CMAKE_GENERATOR="Ninja"
export NINJA_STATUS="[%f/%t %o/sec]"

# =============================================================================
# Application Specific
# =============================================================================

export HOMEBREW_BUNDLE_FILE="${XDG_CONFIG_HOME}/homebrew/Brewfile"
export GHOSTTY_CONFIG="${XDG_CONFIG_HOME}/ghostty/config"

# =============================================================================
# Legacy Compatibility
# =============================================================================

[[ -S "$HOME/.bitwarden-ssh-agent.sock" ]] && \
    export SSH_AUTH_SOCK="$HOME/.bitwarden-ssh-agent.sock"


# =============================================================================
# TOOL CONFIGURATION
# =============================================================================
# FZF
if command -v fd >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
elif command -v rg >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi
export FZF_DEFAULT_OPTS='--height 40% --border --layout=reverse --info=inline'

# Ripgrep config (XDG)
RG_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/ripgrep/config"
[[ ! -f "$RG_CONFIG" ]] && mkdir -p "$(dirname "$RG_CONFIG")" && cat > "$RG_CONFIG" << 'EOF' 2>/dev/null
--smart-case
--hidden
--follow
--glob=!.git/*
--glob=!node_modules/*
--glob=!.DS_Store
EOF
[[ -f "$RG_CONFIG" ]] && export RIPGREP_CONFIG_PATH="$RG_CONFIG"





# =============================================================================
# TOOL INITIALIZATION
# =============================================================================
# direnv
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"

# pyenv
if command -v pyenv >/dev/null 2>&1; then
    export PYENV_ROOT="$HOME/.pyenv"
    [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init - zsh)"
fi

# z (jump around) & fzf key bindings
for script in \
    "/opt/homebrew/etc/profile.d/z.sh" "/usr/local/etc/profile.d/z.sh" \
    "$HOME/.fzf/shell/completion.zsh" \
    "$HOME/.fzf/shell/key-bindings.zsh"; do
    [[ -f "$script" ]] && source "$script"
done

# GitHub Copilot
if command -v gh >/dev/null 2>&1 && gh extension list 2>/dev/null | grep -q copilot; then
    eval "$(gh copilot alias -- zsh)" 2>/dev/null || true
fi





# -----------------------------------------------------------------------------
# Tool-specific environment variables
# -----------------------------------------------------------------------------
export NODE_ENV="${NODE_ENV:-development}"
export GREP_COLOR='1;32'
export GREP_OPTIONS='--color=auto'

# GPG
export GPG_TTY=$(tty)
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"

# Privacy / telemetry
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export NEXT_TELEMETRY_DISABLED=1
export DO_NOT_TRACK=1

