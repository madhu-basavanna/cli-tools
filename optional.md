# Optional CLI Tools

<details>
<summary>Set up bash</summary>

### Add this to ~/.bashrc to enable packages
```bash
# Bash history configuration
HISTFILE=~/.bash_history
HISTSIZE=10000
HISTFILESIZE=10000
HISTCONTROL=ignorespace:erasedups
HISTIGNORE="&:ls:ll:la:l.:pwd:exit:clear:history"

# Enable history options
shopt -s histappend    # Append to history file, don't overwrite
shopt -s cmdhist       # Save multi-line commands as one entry
shopt -s lithist       # Preserve newlines in history

# Setup color for bash
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# To enable vim motions in bash shell
set -o vi

# For server
if [ -f /usr/share/doc/fzf/examples/key-bindings.bash ]; then
    source /usr/share/doc/fzf/examples/key-bindings.bash
fi

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

alias tat='tmux attach -t'
alias ta='tmux attach'
alias tn='tmux new-session -s'
alias tl='tmux ls'
alias ls='eza'
alias ll='eza -lah'
alias l='eza -lh'
```
</details>

<details>
<summary>Install Nerd Font</summary>

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
</details>

<details>
<summary>Setup tmux</summary>

### 1. Download and setup the tmux-plugin-manager
```bash
# Create directory and download TPM
mkdir -p ~/.tmux/plugins
cd ~/.tmux/plugins
git clone https://github.com/tmux-plugins/tpm
```
### 2. Copy the config to ~/.tmux.conf
```bash
# options to make tmux more pleasant

set -g mouse on
# set -g escape-time 0

# Terminal and encoding settings optimized for modern terminals like Warp
set -g default-terminal "tmux-256color"

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
</details>

<details>
<summary>Install zellij via terminal</summary>

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
</details>

<details>
<summary>If unknown command --bash error for fzf then</summary>

Source the fzf key bindings and make them persistent across new terminal sessions by adding the below command to ~/.bashrc
```bash
if [ -f /usr/share/doc/fzf/examples/key-bindings.bash ]; then
    source /usr/share/doc/fzf/examples/key-bindings.bash
fi
```
Below are the suggested fixes by Deepseek but didn't find those paths in the server after fzf installation. Keeping these commands for informational purposes; just the above keybindings command is enough.
```bash
source /usr/share/doc/fzf/examples/completion.bash
```
Alternative paths:
```bash
source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash
```
</details>

