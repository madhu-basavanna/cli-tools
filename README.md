# Install essential cli tools

## Install nala (Better APT frontend)

### 1. Install nala package manager

```bash
sudo apt install nala
```

nala is a frontend for APT with better output, parallel downloads, and improved user experience.

## Replace default vim with vim-gtk3

### 1. Download vim-gtk3

```bash
sudo nala install vim-gtk3
```

### 2. Verify current setup and update the default to vim-gtk3

```bash
sudo update-alternatives --config vim
```

### 3. Add below config to ~/.vimrc to enable yankking to system clipboard, display line number and key bindings for save and quit

To use system clipboard as default

```vim
set clipboard=unnamedplus
set number
set relativenumber

" Map Ctrl+S to save only
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>a

" Map Ctrl+Q to quit
nnoremap <C-q> :q<CR>
inoremap <C-q> <Esc>:q<CR>a
```

## Install fzf, zoxide and fd-find

### 1. Download fzf

```bash
sudo nala install fzf zoxide fd-find
```

### 2. Add this to ~/.bashrc to enable packages

```bash
eval "$(fzf --bash)"

gcb() {
    git branch | fzf --preview 'git show --color=always {-1}' \
                    --bind 'enter:become(git checkout {-1})' \
                    --height 40% --layout reverse
}

eval "$(zoxide init bash)"

# Use zoxide's interactive mode with fzf
zi() {
  local dir
  dir=$(zoxide query -i -- "$@") && cd "$dir"
}

# Alt + d to open recent dir and search
bind '"\ed":"zi\n"'

alias fd=fdfind

ff() {
  local file editor
  editor=$(command -v vim || command -v nvim)
  file=$(fd -HI --type f . | fzf --preview 'sed -n "1,200p" {}' --height 40% --reverse )
  [ -n "$file" ] && "$editor" "$file"
}
```

### 3. If unknown command --bash error for fzf then

Source the fzf key bindings and make them persistant across new terminal session by adding the below command to ~/.bashrc

```bash
if [ -f /usr/share/doc/fzf/examples/key-bindings.bash ]; then
    source /usr/share/doc/fzf/examples/key-bindings.bash
fi
```

Below are the suggested fix by Deepseek but didn't find those paths in the server after fzf installation, Keeeping these commands for informational purpose just the above keybindings commands is enough

```bash
source /usr/share/doc/fzf/examples/completion.bash
```

Alternative paths

```bash
source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash
```

## Optional

[optional](optional.md)
