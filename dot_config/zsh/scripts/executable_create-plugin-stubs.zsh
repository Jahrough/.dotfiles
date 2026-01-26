#!/usr/bin/env zsh
set -euo pipefail

PLUGIN_ROOT="${ZDOTDIR:-$HOME/.config/zsh}/plugins"
mkdir -p "$PLUGIN_ROOT"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
  zsh-history-substring-search
  colored-man-pages
  z
  fzf
  ssh-agent
  tmux
  nvm
  pyenv
  rvm
  rbenv
  jenv
  scalaenv
  golang
  rust
  php
  lua
  gradle
  maven
  brew
  npm
  yarn
  aws
  azure
  gcloud
  heroku
  digitalocean
  docker
  kubectl
  kubectx
  kubens
  docker-compose
  docker-machine
  helm
  minikube
  terraform
  ansible
  vagrant
  macos
)

for plugin in "${plugins[@]}"; do
  dir="$PLUGIN_ROOT/$plugin"
  file="$dir/$plugin.plugin.zsh"

  mkdir -p "$dir"

  [[ -f "$file" ]] && continue

  cat > "$file" <<'EOF'
# Auto-generated plugin stub
# Silent, instant-prompt safe

[[ -o interactive ]] || return 0
EOF
done
