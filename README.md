# Install essential cli tools

## Replace default vim with vim-gtk3

`bash`
sudo apt-get install vim-gtk3

## Verify current setup and update the default to vim-gtk3

sudo update-alternatives --config vim

## Add below config to ~/.vimrc to enable yankking to system clipboard

" Use system clipboard as default \
set clipboard=unnamedplus

## Install fzf

`bash`
sudo apt install fzf

## Add this to ~/.bashrc to enable fzf and also use the gcb to git checkout

`bash`
eval "$(fzf --bash)"

gcb() {
    git branch | fzf --preview 'git show --color=always {-1}' \
                    --bind 'enter:become(git checkout {-1})' \
                    --height 40% --layout reverse
}
