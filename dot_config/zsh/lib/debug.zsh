# Enable profiling: zsh -ic 'zprof' or set ZSH_PROF=1
if [[ -n "$ZSH_PROF" ]]; then
  zmodload zsh/zprof
fi

# Debug mode
if [[ -n "$ZSH_DEBUG" ]]; then
  setopt XTRACE
  PS4=$'%D{%H:%M:%S} %N:%i> '
fi

# Benchmark shell startup
function zsh-benchmark() {
  local total=0
  for i in {1..10}; do
    local start=$(($(date +%s%N)/1000000))
    /usr/bin/env zsh -i -c exit
    local end=$(($(date +%s%N)/1000000))
    local elapsed=$((end-start))
    total=$((total+elapsed))
    echo "Run $i: ${elapsed}ms"
  done
  echo "Average: $((total/10))ms"
}