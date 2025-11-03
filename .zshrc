# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/dotfiles}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add zsh plugins
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

autoload -Uz compinit && compinit

zinit cdreplay -q

# History
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt extendedglob
bindkey -v

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath'

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

# fdfind to work with fzf to display list of file names
ff() {
  local file editor
  editor=$(command -v nvim || command -v vim)
  file=$(fd -HI --type f . | fzf --preview 'sed -n "1,200p" {}' --height 40% --reverse )
  [ -n "$file" ] && "$editor" "$file"
}

# yazi to get current working dir context
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# Load environment variables from ~/.env file
if [ -f ~/.env ]; then
  while IFS= read -r line; do
    # Skip empty lines and comments
    if [ -n "$line" ] && [[ ! "$line" =~ ^[[:space:]]*# ]]; then
	export "$line"
    fi
  done < ~/.env
fi

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
alias ls='eza'
alias ll='eza -lah --icons'
alias l='eza -lh --icons'
alias ki='kitten icat'

. "$HOME/.local/bin/env"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export TERM=xterm-256color
export EDITOR=nvim
export VISUAL=nvim
export GPG_TTY=$(tty)
#export GITLAB_TOKEN=$(pass show gitlab)
#export GITHUB_TOKEN=$(pass show github)
#export HF_TOKEN=$(pass show hf)
