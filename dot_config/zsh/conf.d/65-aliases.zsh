# =============================================================================
# ALIASES - Command Shortcuts and Improvements
# Modern CLI tools with intelligent fallbacks
# Compatible with macOS (BSD) and Linux (GNU)
# XDG-compliant where applicable
# =============================================================================

# -----------------------------------------------------------------------------
# LS Enhancements — modern tools with graceful fallbacks
# -----------------------------------------------------------------------------
# Backend detection (priority: eza → exa → gls → ls)
if command -v eza >/dev/null 2>&1; then
    _ls_cmd="eza"
elif command -v exa >/dev/null 2>&1; then
    _ls_cmd="exa"
elif command -v gls >/dev/null 2>&1; then
    _ls_cmd="gls"
else
    _ls_cmd="ls"
fi

# Backend-specific flags
_ls_long="-lh"
_ls_all="-A"
_ls_group=""
_ls_color=""
_ls_icons=""
_ls_tree=""
_ls_classify=""
_ls_time=""

case "$_ls_cmd" in
    eza)
        _ls_group="--group-directories-first"
        _ls_icons="--icons"
        _ls_classify="--classify"
        _ls_time="--time-style=long-iso"
        _ls_tree="--tree"
        ;;
    exa)
        _ls_group="--group-directories-first"
        _ls_icons="--icons"
        _ls_classify="--classify"
        _ls_tree="--tree"
        ;;
    gls)
        _ls_group="--group-directories-first"
        _ls_color="--color=auto"
        ;;
    ls)
        if ls --color=auto >/dev/null 2>&1; then
            _ls_group="--group-directories-first"
            _ls_color="--color=auto"
        else
            _ls_long="-lhG"
        fi
        ;;
esac

# Core aliases
if [[ "$_ls_cmd" == "eza" || "$_ls_cmd" == "exa" ]]; then
    alias ls="$_ls_cmd -l $_ls_group $_ls_icons $_ls_classify $_ls_time"
    alias ll="$_ls_cmd $_ls_long $_ls_group $_ls_icons $_ls_classify $_ls_time"
    alias l="$_ls_cmd $_ls_long $_ls_icons $_ls_classify"
    alias la="$_ls_cmd -l $_ls_all $_ls_group $_ls_icons $_ls_classify $_ls_time"
    alias lsg="$_ls_cmd -l $_ls_all $_ls_group $_ls_icons $_ls_classify $_ls_time --git"
    alias llg="$_ls_cmd $_ls_long $_ls_group $_ls_icons $_ls_classify $_ls_time --git"
    alias tree="$_ls_cmd $_ls_tree $_ls_icons"
    alias lt="$_ls_cmd $_ls_tree --level=2 $_ls_icons"
    alias lt3="$_ls_cmd $_ls_tree --level=3 $_ls_icons"
else
    alias ls="command $_ls_cmd -l $_ls_group $_ls_color"
    alias ll="command $_ls_cmd $_ls_long $_ls_group $_ls_color"
    alias la="command $_ls_cmd -l $_ls_all $_ls_group $_ls_color"
    alias l="command $_ls_cmd $_ls_long $_ls_color"
    # Tree fallback
    if command -v tree >/dev/null 2>&1; then
        alias tree='tree'
        alias lt='tree -L 2'
        alias lt3='tree -L 3'
    else
        alias tree='find . -print | sed -e "s;[^/]*/;|____;g;s;____|; |;g"'
    fi
fi

alias lsd='ls -d */ 2>/dev/null || echo "No directories found"'

unset _ls_cmd _ls_long _ls_all _ls_group _ls_color _ls_icons \
      _ls_tree _ls_classify _ls_time

# -----------------------------------------------------------------------------
# Cat - Modern replacement with fallback
# -----------------------------------------------------------------------------
if command -v bat >/dev/null 2>&1; then
    alias cat='bat --paging=never --style=plain'
    alias ccat='bat --paging=never'
    alias bcat='bat'
fi

# -----------------------------------------------------------------------------
# File Operations - safe and verbose
# -----------------------------------------------------------------------------
alias mkdir='mkdir -pv'
alias rm='rm -i'
alias chown='chown -v'
alias chmod='chmod -v'

if command -v gcp >/dev/null 2>&1; then alias cp='gcp -iv'; else alias cp='cp -iv'; fi
if command -v gmv >/dev/null 2>&1; then alias mv='gmv -iv'; else alias mv='mv -iv'; fi

# -----------------------------------------------------------------------------
# System Monitoring
# -----------------------------------------------------------------------------
if command -v btop >/dev/null 2>&1; then
    alias top='btop'
    alias htop='btop'
elif command -v htop >/dev/null 2>&1; then
    alias top='htop'
fi

if command -v ncdu >/dev/null 2>&1; then alias du='ncdu --color dark'; fi

# -----------------------------------------------------------------------------
# Search & Text Processing
# -----------------------------------------------------------------------------
if command -v rg >/dev/null 2>&1; then
    alias grep='rg'
    alias rgrep='rg'
elif command -v ggrep >/dev/null 2>&1; then
    alias grep='ggrep --color=auto'
else
    alias grep='grep --color=auto'
fi

alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

if command -v gsed >/dev/null 2>&1; then alias sed='gsed'; fi
if command -v gawk >/dev/null 2>&1; then alias awk='gawk'; fi
if command -v gdiff >/dev/null 2>&1; then alias diff='gdiff --color=auto'; else alias diff='diff --color=auto 2>/dev/null || diff'; fi

# -----------------------------------------------------------------------------
# Git Shortcuts
# -----------------------------------------------------------------------------
alias g='git'
alias gs='git status -sb'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpl='git pull'
alias gd='git diff'
alias gds='git diff --staged'
alias gdt='git difftool'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias glog='git log --oneline --graph --decorate'
alias gloga='git log --oneline --graph --decorate --all'
alias gst='git stash'
alias gstp='git stash pop'
alias gstl='git stash list'
alias gf='git fetch'
alias gfa='git fetch --all'
alias gr='git rebase'
alias gri='git rebase -i'
alias gm='git merge'
alias gcp='git cherry-pick'
alias gcl='git clone'
alias gclean='git clean -fd'
alias grh='git reset HEAD'
alias grhh='git reset --hard HEAD'

if command -v delta >/dev/null 2>&1; then
    alias gd='git diff --color=always | delta'
    alias gds='git diff --staged --color=always | delta'
    alias glog='git log --oneline --graph --color=always | delta'
fi

# -----------------------------------------------------------------------------
# Docker & Compose
# -----------------------------------------------------------------------------
alias d='docker'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dex='docker exec -it'
alias dstop='docker stop $(docker ps -q)'
alias drm='docker rm $(docker ps -aq)'
alias drmi='docker rmi $(docker images -q)'

alias dc='docker compose'
alias dcu='docker compose up'
alias dcud='docker compose up -d'
alias dcd='docker compose down'
alias dcr='docker compose restart'
alias dcl='docker compose logs'
alias dclf='docker compose logs -f'

# -----------------------------------------------------------------------------
# Kubernetes
# -----------------------------------------------------------------------------
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get services'
alias kgd='kubectl get deployments'
alias kgn='kubectl get nodes'
alias kdp='kubectl describe pod'
alias kds='kubectl describe service'
alias kl='kubectl logs'
alias klf='kubectl logs -f'
alias kex='kubectl exec -it'
alias kctx='kubectl config get-contexts'
alias kns='kubectl config set-context --current --namespace'
if command -v k9s >/dev/null 2>&1; then alias k9='k9s'; fi

# -----------------------------------------------------------------------------
# Network & System Utilities
# -----------------------------------------------------------------------------
alias ping='ping -c 5'
alias myip='curl -s ifconfig.me && echo'
alias localip='ipconfig getifaddr en0 2>/dev/null || hostname -I 2>/dev/null | cut -d" " -f1'
alias ports='lsof -i -P -n | grep LISTEN'
alias listening='lsof -i -P | grep LISTEN'
if command -v speedtest-cli >/dev/null 2>&1; then alias speedtest='speedtest-cli'; fi

# -----------------------------------------------------------------------------
# Package Managers
# -----------------------------------------------------------------------------
alias br='brew'
alias bru='brew update && brew upgrade && brew cleanup'
alias brs='brew search'
alias bri='brew install'
alias brun='brew uninstall'
alias brinfo='brew info'
alias brl='brew list'
alias brc='brew cleanup'
alias brd='brew doctor'

if command -v apt >/dev/null 2>&1; then
    alias aptu='sudo apt update && sudo apt upgrade'
    alias apti='sudo apt install'
    alias aptr='sudo apt remove'
    alias apts='apt search'
fi



# -----------------------------------------------------------------------------
# Database CLI
# -----------------------------------------------------------------------------
if command -v mycli >/dev/null 2>&1; then alias mysql='mycli'; fi
if command -v pgcli >/dev/null 2>&1; then alias postgres='pgcli'; alias psql='pgcli'; fi
if command -v litecli >/dev/null 2>&1; then alias sqlite='litecli'; fi

# -----------------------------------------------------------------------------
# Editors
# -----------------------------------------------------------------------------
if command -v nvim >/dev/null 2>&1; then
    alias vim='nvim'
    alias vi='nvim'
    alias v='nvim'
fi

# -----------------------------------------------------------------------------
# Directory Navigation
# -----------------------------------------------------------------------------
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'
alias -- -='cd -'
alias dl='cd ~/Downloads'
alias dt='cd ~/Desktop'
alias docs='cd ~/Documents'
alias dev='cd ~/Developer 2>/dev/null || cd ~/dev 2>/dev/null || cd ~/projects 2>/dev/null || cd ~/Projects 2>/dev/null || { echo "No dev directory found"; return 1; }'

# -----------------------------------------------------------------------------
# Zsh Configuration Management
# -----------------------------------------------------------------------------
alias sz='source $ZDOTDIR/.zshrc'
alias reload='exec zsh'
alias zshrc='${EDITOR:-vim} $ZDOTDIR/.zshrc'
alias zshenv='${EDITOR:-vim} ~/.zshenv'
alias zshlocal='${EDITOR:-vim} $ZDOTDIR/.zshrc.local'
alias aliases='${EDITOR:-vim} $ZDOTDIR/10-aliases.zsh'
alias functions='${EDITOR:-vim} $ZDOTDIR/20-functions.zsh'

# -----------------------------------------------------------------------------
# History Shortcuts
# -----------------------------------------------------------------------------
alias h='history'
alias hg='history | grep'
alias hs='history | grep'

# -----------------------------------------------------------------------------
# Application-Specific & Fun
# -----------------------------------------------------------------------------
if command -v ghostty >/dev/null 2>&1; then alias ghostty_reload='ghostty reload'; fi
alias myweather='curl -s "wttr.in/?format=3"'
alias myforecast='curl -s "wttr.in"'

if command -v cmatrix >/dev/null 2>&1; then alias matrix='cmatrix -b'; fi
if command -v figlet >/dev/null 2>&1; then alias ascii='figlet'; fi

# -----------------------------------------------------------------------------
# File Finding Utilities
# -----------------------------------------------------------------------------
alias ffile='find . -type f -name'
alias fdir='find . -type d -name'
if command -v pbcopy >/dev/null 2>&1; then alias pwdcp='pwd | tr -d "\n" | pbcopy'; fi

# -----------------------------------------------------------------------------
# Cleanup Utilities
# -----------------------------------------------------------------------------
alias cleanup='find . -type f -name "*.DS_Store" -ls -delete'
alias emptytrash='rm -rf ~/.Trash/*'
