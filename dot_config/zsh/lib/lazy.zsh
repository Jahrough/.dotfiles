# Lazy load functions
function lazy_load() {
  local cmd="$1"
  shift
  local init_script="$@"
  
  eval "function ${cmd}() {
    unfunction ${cmd}
    eval '${init_script}'
    ${cmd} \"\$@\"
  }"
}
