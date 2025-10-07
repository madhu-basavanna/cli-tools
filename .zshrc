
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

# Use zoxide's interactive mode with fzf
zi() {
  local dir
  dir=$(zoxide query -i -- "$@") && cd "$dir"
}

# Alt + d to open recent dir and search
bindkey "\ed" zi

alias fd=fdfind

ff() {
  local file editor
  editor=$(command -v vim || command -v nvim)
  file=$(fd -HI --type f . | fzf --preview 'sed -n "1,200p" {}' --height 40% --reverse )
  [ -n "$file" ] && "$editor" "$file"
}

# Generic search to specify the folder
rgd() { rg "$1.*$2|$2.*$1" "${3:-.}"; }
# Usage: rgn docker prune
