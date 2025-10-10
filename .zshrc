
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

# Load environment variables from ~/.env file
  if [ -f ~/.env ]; then
      while IFS= read -r line; do
          # Skip empty lines and comments
          if [ -n "$line" ] && [[ ! "$line" =~ ^[[:space:]]*# ]]; then
              export "$line"
          fi
      done < ~/.env
  fi

# if you select the alredy active branch thorws an error
gsb() {
    git branch -a | fzf \
        --preview 'git show --color=always {1}' \
        --bind 'enter:become(git switch $(echo {1} | sed "s#remotes/origin/##"))' \
        --height 40% --layout=reverse
}

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


rgn() { rg "$1.*$2|$2.*$1" "$HOME/Notes"; }

# Generic search to specify the folder
rgd() { rg "$1.*$2|$2.*$1" "${3:-.}"; }
# Usage: rgn docker prune

# Enable dynamic terminal titles
autoload -Uz add-zsh-hook

# Function to set title
set_title() {
  # Get user@host if SSH, otherwise just current dir
  if [[ -n $SSH_CONNECTION ]]; then
    print -Pn "\e]2;SSH: [%m] - %~\a"
  else
    print -Pn "\e]2;%n@%m - %~\a"
  fi
}

# Update title on every prompt
add-zsh-hook precmd set_title

alias ld=lazydocker
alias lg=lazygit
alias lssh=lazyssh
alias lj=lazyjournal
alias ta='tmux attach'
alias tn='tmux new-session -s'
alias tl='tmux ls'
