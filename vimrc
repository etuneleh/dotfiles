call plug#begin('~/.config/nvim/plugged')
Plug 'cocopon/iceberg.vim'
Plug 'lervag/vimtex'
Plug 'tpope/vim-commentary'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'tpope/vim-surround'
Plug 'w0rp/ale'
Plug 'ajh17/VimCompletesMe'
Plug 'ervandew/supertab'
Plug 'godlygeek/tabular'

call plug#end()
"configuration starts here
"
""
let mapleader = "\<Space>"
set clipboard+=unnamedplus
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsEditSplit = "vertical"
let g:UltiSnipsSnippetsDir = $HOME."/.config/nvim/my-snippets"
"enable english spell checking for .tex-Documents
"au Filetype tex setlocal spell spelllang=en
"enable german spell checking for .tex-Documents
au BufEnter *.tex setlocal filetype=tex
au Filetype tex setlocal spell spelllang=de_de 
let g:vimtex_view_automatic=1
let g:vimtex_view_general_viewer = 'zathura'
let g:vimtex_view_method = 'zathura'
let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
let g:vimtex_view_general_options_latexmk = '--unique'
let g:UltiSnipsSnippetDirectories = ['UltiSnips', $HOME.'/.config/nvim/my-snippets']
let g:UltiSnipsEnableSnipMate = 0
"öffnet und sourcet vimrc
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
"colorscheme
colorscheme iceberg
" supertab
let g:SuperTabDefaultCompletionType = "<c-n>"
" 
" vimtex:Alt-I for "\item"
call vimtex#imaps#add_map({
  \ 'lhs' : '<m-i>',
  \ 'rhs' : '\item ',
  \ 'leader' : '',
  \ 'wrapper' : 'vimtex#imaps#wrap_environment',
  \ 'context' : ["itemize", "enumerate"],
  \})

set number
set cursorline
set tw=80
