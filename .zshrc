
# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' max-errors 2 numeric
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt extendedglob
bindkey -v
# End of lines configured by zsh-newuser-install

# Two line colored prompt
PROMPT='%F{green}%n%f@%F{blue}%m%f:%F{yellow}%~%f'$'\n''%# '

# For laptop
eval "$(fzf --zsh)"

# For server
#if [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]; then
#  source /usr/share/doc/fzf/examples/key-bindings.zsh
#fi

eval "$(zoxide init zsh)"

# Use zoxide's interactive mode with fzf as a zsh widget
zi-widget() {
  local dir
  dir=$(zoxide query -i) && cd "$dir"
  zle reset-prompt
}
zle -N zi-widget
bindkey "\ed" zi-widget

alias fd=fdfind

ff() {
  local file editor
  editor=$(command -v nvim || command -v vim)
  file=$(fd -HI --type f . | fzf --preview 'sed -n "1,200p" {}' --height 40% --reverse )
  [ -n "$file" ] && "$editor" "$file"
}

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

rgn() { rg "$1.*$2|$2.*$1" "$HOME/Notes"; }

# Generic search to specify the folder
rgd() { rg "$1.*$2|$2.*$1" "${3:-.}"; }
# Usage: rgn docker prune

alias ld=lazydocker
alias lg=lazygit
alias lssh=lazyssh
alias lj=lazyjournal
alias tat='tmux attach -t'
alias ta='tmux attach'
alias tn='tmux new-session -s'
alias tl='tmux ls'
alias ll='ls -la'
alias ki='kitten icat'

export TERM=xterm-256color
export EDITOR=nvim
export VISUAL=nvim

. "$HOME/.local/bin/env"
