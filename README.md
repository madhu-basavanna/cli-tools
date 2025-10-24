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

#### optional if some other terminal emulator is installed and if you want to set it to default use
```bash
sudo update-alternatives --config x-terminal-emulator
```

### 3. Install zsh, curl, stow, fzf, zoxide, ripgrep and fd-find

```bash
sudo nala install curl fzf zoxide fd-find stow zsh fastfetch eza btop
```

Change shell from bash to zsh
```bash
sudo usermod -s /usr/bin/zsh $USER
sudo chsh -s /usr/bin/zsh $USER
chsh -s $(which zsh)
```

Create dotfiles dir and switch to it
```bash
mkdir -p ~/dotfiles && cd ~/dotfiles
```

### 4. Git clone the repo and initilize the dotfiles
```bash
git clone --recurse-submodules https://github.com/madhu-basavanna/cli-tools.git . && stow .
```

## Optional

[optional](optional.md)
