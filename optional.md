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
