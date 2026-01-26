# =============================================================================
# Prompt & Framework Initialization
# =============================================================================
# - Oh My Zsh bootstrap
# - Powerlevel10k theme selection
# - NO output
# - NO instant-prompt logic
# =============================================================================

# -----------------------------------------------------------------------------
# Oh My Zsh (XDG-compliant)
# -----------------------------------------------------------------------------

export ZSH="${XDG_CONFIG_HOME}/oh-my-zsh"

# Theme MUST be set before sourcing OMZ
ZSH_THEME="powerlevel10k/powerlevel10k"

# Load Oh My Zsh (silent, instant-prompt safe)
[[ -r "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

# -----------------------------------------------------------------------------
# Powerlevel10k Configuration
# -----------------------------------------------------------------------------

# Load prompt configuration AFTER OMZ
[[ -r "${XDG_CONFIG_HOME}/zsh/p10k.zsh" ]] && source "${XDG_CONFIG_HOME}/zsh/p10k.zsh"
