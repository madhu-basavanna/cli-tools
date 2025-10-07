set clipboard=unnamedplus
set number
set relativenumber

" Map Ctrl+S to save only
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>a

" Map Ctrl+Q to quit
nnoremap <C-q> :q<CR>
inoremap <C-q> <Esc>:q<CR>a
