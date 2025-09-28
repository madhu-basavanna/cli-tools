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

tmux.conf

```bash
# Options to make tmux more pleasant
set -g mouse on
set -g escape-time 0

# Terminal and encoding settings optimized for modern terminals like Warp
set -g default-terminal "tmux-256color"

unbind r
bind r source-file ~/.config/tmux/tmux.conf

# Shift Alt vim keys to switch windows
bind -n M-H previous-window
bind -n M-L next-window

# Start windows and panes at 1, not 0
set -g base-index 1
set -g pane-base-index 1
set-window-option -g pane-base-index 1
set-option -g renumber-windows on

# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-yank'
set -g @plugin 'catppuccin/tmux'
set -g @plugin 'christoomey/vim-tmux-navigator'

# set vi-mode
set-window-option -g mode-keys vi
# keybindings
bind-key -T copy-mode-vi v send-keys -X begin-selection
bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

# Open panes in current directory
bind '"' split-window -v -c "#{pane_current_path}"
bind % split-window -h -c "#{pane_current_path}"

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'
```

