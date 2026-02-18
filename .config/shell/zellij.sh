#!/bin/bash
# =============================
# ZELLIJ POWER ALIASES + HELPERS
# =============================

alias z='zellij'
alias zls='zellij list-sessions'
alias zk='zellij kill-session'
alias zka='zellij kill-all-sessions'
# New session
alias zn='zellij --session'

# Attach to the last/most recent session
za() {
    local last
    last=$(zellij list-sessions --short | tail -n 1)

    if [ -z "$last" ]; then
        echo "No sessions available."
        return 1
    fi

    echo "Attaching to last session: $last"
    zellij attach "$last"
}

# Attach/create
zac() {
    if [ -z "$1" ]; then
        echo "Usage: za <session-name>"
        return 1
    fi
    zellij attach --create "$1"
}

# FZF picker
zf() {
    local session
    session=$(zellij list-sessions --short |
        fzf --height=40% --reverse --border --prompt="Select session: ")
    [ -n "$session" ] && zellij attach "$session"
}

# Project folder based session
zp() {
    local name="$(basename "$PWD")"
    echo "Opening session: $name"
    zellij attach --create "$name"
}
