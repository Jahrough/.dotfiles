# =============================================================================
# conf.d/95-macos.zsh — macOS interactive config
# =============================================================================

[[ "$OSTYPE" != darwin* ]] && return

# Interactive-only conveniences
alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
