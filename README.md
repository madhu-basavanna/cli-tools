# Install essential cli tools

## Replace default vim with vim-gtk3

### 1. Download vim-gtk3

`sudo apt-get install vim-gtk3`

### 2. Verify current setup and update the default to vim-gtk3

`sudo update-alternatives --config vim`

### 3. Add below config to ~/.vimrc to enable yankking to system clipboard

To use system clipboard as default

`set clipboard=unnamedplus`

## Install fzf

### 1. Download fzf

`sudo apt install fzf`

### 2. Add this to ~/.bashrc to enable fzf and also use the gcb to git checkout

`eval "$(fzf --bash)"`

`gcb() {
    git branch | fzf --preview 'git show --color=always {-1}' \
                    --bind 'enter:become(git checkout {-1})' \
                    --height 40% --layout reverse
}`

### 3. If unknown command --bash error for fzf then

Source the fzf key bindings and make them persistant across new terminal session by adding the below command to ~/.bashrc

`if [ -f /usr/share/doc/fzf/examples/key-bindings.bash ]; then
    source /usr/share/doc/fzf/examples/key-bindings.bash
fi`

Below are the suggested fix by Deepseek but didn't find those paths in the server after fzf installation, Keeeping these commands for informational purpose just the above keybindings commands is enough

`source /usr/share/doc/fzf/examples/completion.bash`

Alternative paths

`source /usr/share/fzf/key-bindings.bash`

`source /usr/share/fzf/completion.bash`

## Install zellij via terminal

### 1. Download
`curl -L -o zellij.tar.gz "https://github.com/zellij-org/zellij/releases/latest/download/zellij-no-web-x86_64-unknown-linux-musl.tar.gz"`

### 2. Verify it arrived
`ls -lh zellij.tar.gz`

### 3. Extract everything
`tar -xzf zellij.tar.gz`

### 4. See what came out
`ls -l`

### 5. Make it executable and move it to bin to use everywhere 
make it executable

`chmod +x zellij`

put it on your PATH

`sudo mv zellij /usr/local/bin/`
