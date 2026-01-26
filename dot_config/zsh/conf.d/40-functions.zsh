# =============================================================================
# functions.zsh — high-level user functions (modular & DRY)
# =============================================================================

# Load helper library first
[[ -f "${ZDOTDIR:-$HOME/.config/zsh}/lib/helper.zsh" ]] && source "${ZDOTDIR:-$HOME/.config/zsh}/lib/helper.zsh"

# -----------------------------------------------------------------------------
# Directory & File Management
# -----------------------------------------------------------------------------
mkcd() {
    require_arg "$1" "mkcd" || return 1
    mkdir -p "$1" && cd "$1" || return 1
}

mktouch() {
    require_arg "$1" "mktouch" || return 1
    mkdir -p "$(dirname "$1")" && touch "$1"
}

backup() {
    require_arg "$1" "backup" || return 1
    [[ ! -e "$1" ]] && echo "Error: '$1' does not exist" >&2 && return 1
    cp -r "$1" "${1}.backup.$(timestamp)"
    echo "Backup created: ${1}.backup.$(timestamp)"
}

fsize() {
    require_arg "$1" "fsize" || return 1
    [[ ! -e "$1" ]] && echo "Error: '$1' does not exist" >&2 && return 1
    du -sh "$1"
}

sizes() {
    local dir="${1:-.}"
    require_dir "$dir" || return 1
    if command -v gdu >/dev/null 2>&1; then
        gdu -sh "$dir"/* 2>/dev/null | sort -hr
    else
        du -sh "$dir"/* 2>/dev/null | sort -hr
    fi
}

extract() {
    require_file "$1" "extract" || return 1
    case "${1:l}" in
        *.tar.bz2|*.tbz2) tar xjf "$1" ;;
        *.tar.gz|*.tgz)   tar xzf "$1" ;;
        *.tar.xz|*.txz)   tar xJf "$1" ;;
        *.tar.lz4)        lz4 -c -d "$1" | tar x ;;
        *.tar.lzma)       unlzma -c "$1" | tar x ;;
        *.tar.zst)        zstd -dc "$1" | tar x ;;
        *.tar)            tar xf "$1" ;;
        *.bz2)            bunzip2 "$1" ;;
        *.rar)            unrar e "$1" ;;
        *.gz)             gunzip "$1" ;;
        *.zip)            unzip "$1" ;;
        *.7z)             7z x "$1" ;;
        *.xz)             unxz "$1" ;;
        *.lzma)           unlzma "$1" ;;
        *.zst)            zstd -d "$1" ;;
        *.deb)            ar x "$1" ;;
        *.rpm)            rpm2cpio "$1" | cpio -idmv ;;
        *)                echo "Error: Cannot extract '$1'" >&2; return 1 ;;
    esac
}

# -----------------------------------------------------------------------------
# Project Navigation
# -----------------------------------------------------------------------------
project_dirs=(
    "$HOME/Projects" "$HOME/projects" "$HOME/Developer"
    "$HOME/code" "$HOME/dev" "$HOME/workspace"
)

proj() {
    require_arg "$1" "proj" || return 1
    for dir in "${project_dirs[@]}"; do
        [[ -d "$dir/$1" ]] && cd "$dir/$1" && echo "Switched to: $dir/$1" && return 0
    done
    echo "Project '$1' not found" >&2
    echo "Searched: ${project_dirs[*]}" >&2
    return 1
}

projlist() {
    echo "Available projects:"
    for dir in "${project_dirs[@]}"; do
        [[ -d "$dir" ]] || continue
        echo "\nIn $dir:"
        find "$dir" -maxdepth 1 -type d -not -path "$dir" -exec basename {} \; 2>/dev/null | sort
    done
}

# -----------------------------------------------------------------------------
# Process Management
# -----------------------------------------------------------------------------
killport() {
    require_arg "$1" "killport" || return 1
    [[ ! "$1" =~ ^[0-9]+$ ]] && echo "Error: Port must be a number" >&2 && return 1
    local pids=$(lsof -ti:$1 2>/dev/null)
    [[ -n "$pids" ]] && echo "$pids" | xargs kill -9 && echo "Processes killed on port $1" || echo "No processes found on port $1"
}

psg() {
    require_arg "$1" "psg" || return 1
    ps aux | head -1
    if command -v rg >/dev/null 2>&1; then
        ps aux | rg -v rg | rg "$1"
    else
        ps aux | grep -v grep | grep "$1"
    fi
}

# -----------------------------------------------------------------------------
# Search & Replace
# -----------------------------------------------------------------------------
findreplace() {
    if [[ $# -lt 3 || $# -gt 4 ]]; then
        echo "Usage: findreplace <dir> <find> <replace> [--backup]" >&2
        return 1
    fi
    local dir="$1" find_pattern="$2" replace_pattern="$3" backup_flag="$4"
    require_dir "$dir" || return 1

    local matches=$(command -v rg >/dev/null 2>&1 && rg -l "$find_pattern" "$dir" || grep -rl "$find_pattern" "$dir")
    [[ -z "$matches" ]] && { echo "No matches found for '$find_pattern'"; return 0; }

    echo "Found matches in $(echo "$matches" | wc -l) file(s). Proceed? (y/N)"
    read -r resp
    [[ "$resp" =~ ^[Yy]$ ]] || { echo "Cancelled"; return 1; }

    local sed_cmd=$(command -v gsed >/dev/null 2>&1 && echo "gsed" || echo "sed")
    local sed_flags="-i${backup_flag:+.backup.$(timestamp)}"
    find "$dir" -type f -exec $sed_cmd $sed_flags "s/$find_pattern/$replace_pattern/g" {} +
    echo "Replacement completed."
}

# -----------------------------------------------------------------------------
# File/Directory Search
# -----------------------------------------------------------------------------
findup() {
    require_arg "$1" "findup" || return 1
    local path=$(pwd)
    while [[ -n "$path" ]]; do
        [[ -e "$path/$1" ]] && { echo "$path/$1"; return 0; }
        path=${path%/*}
    done
    echo "File not found: $1" >&2
    return 1
}

# -----------------------------------------------------------------------------
# FZF-Enhanced Functions
# -----------------------------------------------------------------------------
if command -v fzf >/dev/null 2>&1; then
    fzf-cd() {
        local dir=$(command -v fd >/dev/null 2>&1 && fd --type d 2>/dev/null | fzf +m || find . -type d 2>/dev/null | fzf +m)
        [[ -n "$dir" ]] && cd "$dir"
    }

    fzf-edit() {
        local file=$(command -v fd >/dev/null 2>&1 && fd --type f 2>/dev/null | fzf +m || find . -type f 2>/dev/null | fzf +m)
        [[ -n "$file" ]] && ${EDITOR:-vim} "$file"
    }

    hist() {
        local cmd=$(history -n 1 | fzf --tac --no-sort)
        [[ -n "$cmd" ]] && eval "$cmd"
    }
fi

# -----------------------------------------------------------------------------
# PATH Management
# -----------------------------------------------------------------------------
path_add() { require_dir "$1" && path_add "$1"; }
path_remove() { require_arg "$1" "path_remove" && path_remove "$1"; }
path_show() { echo "$PATH" | tr ':' '\n' | nl; }

# -----------------------------------------------------------------------------
# Quick Notes (XDG)
# -----------------------------------------------------------------------------
note() {
    local note_file=$(xdg_data_file "quick_notes.txt")
    mkdir -p "$(dirname "$note_file")"
    [[ -z "$1" ]] && { [[ -f "$note_file" ]] && tail -10 "$note_file" || echo "No notes"; return 0; }
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$note_file"
    echo "Note added: $*"
}

note_search() {
    require_arg "$1" "note_search"
    local note_file=$(xdg_data_file "quick_notes.txt")
    [[ ! -f "$note_file" ]] && echo "No notes" && return 1
    command -v rg >/dev/null 2>&1 && rg -i "$1" "$note_file" || grep -i "$1" "$note_file"
}

# -----------------------------------------------------------------------------
# Git Helpers
# -----------------------------------------------------------------------------
git_current_branch() { git rev-parse --abbrev-ref HEAD 2>/dev/null; }

gcommit() {
    require_arg "$1" "gcommit" && require_arg "$2" "gcommit"
    local type="$1"; shift; local msg="$*"
    git commit -m "${type}: ${msg}"
}

# -----------------------------------------------------------------------------
# Development Helpers
# -----------------------------------------------------------------------------
serve() {
    local port="${1:-8000}"
    [[ ! "$port" =~ ^[0-9]+$ ]] && echo "Port must be a number" >&2 && return 1
    echo "Serving HTTP on port $port..."
    python3 -m http.server "$port"
}

random_string() { local len="${1:-32}"; LC_ALL=C tr -dc 'A-Za-z0-9' </dev/urandom | head -c "$len"; echo; }

checksum() {
    require_arg "$1" "checksum"
    [[ ! -f "$1" ]] && echo "Not a file: $1" >&2 && return 1
    echo "MD5:    $(md5sum "$1" 2>/dev/null || md5 "$1" 2>/dev/null)"
    echo "SHA256: $(shasum -a 256 "$1" 2>/dev/null || sha256sum "$1" 2>/dev/null)"
}

# -----------------------------------------------------------------------------
# System Information
# -----------------------------------------------------------------------------
sysinfo() {
    echo "System Information:"
    echo "==================="
    echo "Hostname: $(hostname)"
    echo "OS:       $(uname -s) $(uname -r)"
    echo "Uptime:   $(uptime | awk '{print $3,$4}' | sed 's/,//')"
    echo "Shell:    $SHELL ($ZSH_VERSION)"
    echo "CPU:      $(sysctl -n machdep.cpu.brand_string 2>/dev/null || grep 'model name' /proc/cpuinfo | head -1 | cut -d: -f2 | xargs)"
    echo "Memory:   $(free -h 2>/dev/null | awk '/^Mem:/ {print $2}' || sysctl hw.memsize 2>/dev/null | awk '{print $2/1024/1024/1024 " GB"}')"
}
