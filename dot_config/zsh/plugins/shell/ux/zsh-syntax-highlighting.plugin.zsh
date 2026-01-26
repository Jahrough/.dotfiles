# Auto-generated plugin stub
# Silent, instant-prompt safe

[[ -o interactive ]] || return 0

for file in \
  "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" \
  "/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
do
  [[ -f "$file" ]] && source "$file" >/dev/null 2>&1 && break
done
