# Install essential cli tools

## Replace default vim with vim-gtk3

### 1. Download vim-gtk3

```bash
sudo apt-get install vim-gtk3
```

### 2. Verify current setup and update the default to vim-gtk3

```bash
sudo update-alternatives --config vim
```

### 3. Add below config to ~/.vimrc to enable yankking to system clipboard and display line number

To use system clipboard as default

```vim
set clipboard=unnamedplus
```

To display line number in vim editor

```vim
set number
set relativenumber
```

## Install fzf

### 1. Download fzf

```bash
sudo apt install fzf
```

### 2. Add this to ~/.bashrc to enable fzf and also use the gcb to git checkout

```bash
eval "$(fzf --bash)"

gcb() {
    git branch | fzf --preview 'git show --color=always {-1}' \
                    --bind 'enter:become(git checkout {-1})' \
                    --height 40% --layout reverse
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

## Install Nerd Font

### 1. Create fonts directory if it doesn't exist

```bash
mkdir -p ~/.local/share/fonts
```

### 2. Download Nerd Font (JetBrains Mono)

```bash
cd ~/.local/share/fonts
curl -fLo "JetBrains Mono Regular Nerd Font Complete.ttf" \
  https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf
```

### 3. Refresh font cache

```bash
fc-cache -fv
```

### 4. Verify installation

```bash
fc-list | grep -i jetbrains
```
