# Auto-generated plugin stub
# Silent, instant-prompt safe

[[ -o interactive ]] || return 0

for file in \
  "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh" \
  "/usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
do
  [[ -f "$file" ]] && source "$file" >/dev/null 2>&1 && break
done

