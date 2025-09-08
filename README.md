# Install essential cli tools

## Replace default vim with vim-gtk3

`sudo apt-get install vim-gtk3`

## Verify current setup and update the default to vim-gtk3

`sudo update-alternatives --config vim`

## Add below config to ~/.vimrc to enable yankking to system clipboard

To use system clipboard as default

`set clipboard=unnamedplus`

## Install fzf

`sudo apt install fzf`

## Add this to ~/.bashrc to enable fzf and also use the gcb to git checkout

`eval "$(fzf --bash)"`

`gcb() {
    git branch | fzf --preview 'git show --color=always {-1}' \
                    --bind 'enter:become(git checkout {-1})' \
                    --height 40% --layout reverse
}`

## If unknown command --bash error for fzf then

Source the fzf key bindings and completion

`source /usr/share/doc/fzf/examples/key-bindings.bash`

`source /usr/share/doc/fzf/examples/completion.bash`

Alternative paths

`source /usr/share/fzf/key-bindings.bash`

`source /usr/share/fzf/completion.bash`
