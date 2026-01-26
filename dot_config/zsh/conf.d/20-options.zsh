# =============================================================================
# ZSH OPTIONS & HISTORY
# =============================================================================

# Directory navigation
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT

# History
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_IGNORE_ALL_DUPS HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS APPEND_HISTORY INC_APPEND_HISTORY EXTENDED_HISTORY
setopt HIST_VERIFY SHARE_HISTORY

# Completion
setopt COMPLETE_IN_WORD AUTO_MENU ALWAYS_TO_END MENU_COMPLETE

# Globbing
setopt EXTENDED_GLOB GLOB_DOTS

# Correction
setopt CORRECT CORRECT_ALL

# Misc
setopt NO_FLOW_CONTROL INTERACTIVE_COMMENTS NO_BEEP PROMPT_SUBST

# History file and size
HISTFILE="${XDG_STATE_HOME:-$HOME}/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000