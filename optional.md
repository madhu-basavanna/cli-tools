# Optional CLI Tools

## Install zsh and set it up as default shell

### 1. Install zsh

```bash
sudo nala install zsh
```

### 2. Change your default shell to zsh

```bash
chsh -s $(which zsh)
```

### 3. Add this to your ~/.zshrc
```bash

# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' max-errors 2 numeric
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle :compinstall filename '/home/madhu/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt extendedglob
bindkey -v
# End of lines configured by zsh-newuser-install

# Two line colored prompt
PROMPT='%F{green}%n%f@%F{blue}%m%f:%F{yellow}%~%f'$'\n''%# '

# For laptop
eval "$(fzf --zsh)"

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
```
## Install Nerd Font

### 1. Create fonts directory if it doesn't exist

```bash
mkdir -p ~/.local/share/fonts
```

### 2. Download Nerd Font (JetBrains Mono)

```bash
cd ~/.local/share/fonts
curl -L -o HackNerdFont-Regular.ttf "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/HackNerdFont-Regular.ttf"
```

### 3. Refresh font cache

```bash
fc-cache -fv
```

### 4. Verify installation

```bash
fc-list | grep -i jetbrains
```

## Install zellij via terminal

### 1. Download
```bash
curl -L -o zellij.tar.gz "https://github.com/zellij-org/zellij/releases/latest/download/zellij-no-web-x86_64-unknown-linux-musl.tar.gz"
```

### 2. Verify it arrived
```bash
ls -lh zellij.tar.gz
```

### 3. Extract everything
```bash
tar -xzf zellij.tar.gz
```

### 4. See what came out
```bash
ls -l
```

### 5. Make it executable and move it to bin to use everywhere 
make it executable

```bash
chmod +x zellij
```

put it on your PATH

```bash
sudo mv zellij /usr/local/bin/
```
