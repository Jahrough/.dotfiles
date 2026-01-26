# -----------------------------------------------------------------------------
# XDG-Compliant Paths
# -----------------------------------------------------------------------------
xdg_config() { echo "${XDG_CONFIG_HOME:-$HOME/.config}/$1"; }
xdg_data()   { echo "${XDG_DATA_HOME:-$HOME/.local/share}/$1"; }
xdg_cache()  { echo "${XDG_CACHE_HOME:-$HOME/.cache}/$1"; }
xdg_state()  { echo "${XDG_STATE_HOME:-$HOME/.local/state}/$1"; }

xdg_config_file() { xdg_config "$1"; }
xdg_data_file()   { xdg_data "$1"; }

xdg_mkdirs() {
  local dir
  for dir in "$@"; do
    [[ -d "$dir" ]] || mkdir -p "$dir" 2>/dev/null
  done
}
