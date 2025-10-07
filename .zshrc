
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/madhu/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

PROMPT='%B%F{green}%n@%m%f:%F{blue}%~%f%b%# '

source <(fzf --zsh)

gsb() {
    git branch -a | fzf \
        --preview 'git show --color=always {1}' \
        --bind 'enter:become(git switch $(echo {1} | sed "s#remotes/origin/##"))' \
        --height 40% --layout=reverse
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

eval "$(zoxide init zsh)"

# Use zoxide's interactive mode with fzf
zi() {
  local dir
  dir=$(zoxide query -i -- "$@") && cd "$dir"
}

bindkey -s '\ed' 'zi\n'

alias fd=fdfind

ff() {
  local file editor
  editor=$(command -v nvim || command -v vim)
  file=$(fd -HI --type f . | fzf --preview 'sed -n "1,200p" {}' --height 40% --reverse )
  [ -n "$file" ] && "$editor" "$file"
}

export PATH="$HOME/.local/bin:$PATH"

# Search for multiple terms (OR logic) in Notes folder
rgn() {
    rg "$1.*$2|$2.*$1" ~/Notes
}
# Usage: rgn docker prune


# Generic search to specify the folder
rgd() { rg "$1.*$2|$2.*$1" "${3:-.}"; }
