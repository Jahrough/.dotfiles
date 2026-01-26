# Require a non-empty argument
# Usage: require_arg <value> <name>
require_arg() {
  local value="$1" name="${2:-argument}"

  [[ -n "$value" ]] && return 0

  printf 'Usage: %s <%s>\n' "${FUNCNAME[1]:-command}" "$name" >&2
  return 1
}

# Require an existing regular file
# Usage: require_file <path>
require_file() {
  local file="$1"

  [[ -f "$file" ]] && return 0

  printf "Error: '%s' is not a valid file\n" "$file" >&2
  return 1
}

# Require an existing directory
# Usage: require_dir <path>
require_dir() {
  local dir="$1"

  [[ -d "$dir" ]] && return 0

  printf "Error: '%s' is not a valid directory\n" "$dir" >&2
  return 1
}
