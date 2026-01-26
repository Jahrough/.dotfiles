

os_preflight() {
    case "$OS" in
        Darwin) macos_preflight ;;
        Linux) linux_preflight ;;
        *) log "⚠️ Unknown OS: $OS. Preflight checks may be incomplete." ;;
    esac
}
