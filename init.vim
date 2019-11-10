colorscheme onedark
set background=dark
set termguicolors
highlight Normal ctermbg=NONE guibg=NONE 

filetype plugin on

let g:airline_theme='onedark'


set relativenumber
set number
set nowrap

set expandtab
set shiftwidth=4
set softtabstop=4

call plug#begin('~/.config/nvim/plugged')

Plug 'Valloric/YouCompleteMe'
Plug 'rakr/vim-one'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'rust-lang/rust.vim'
Plug 'vim-syntastic/syntastic'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-notes'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'davidgranstrom/nvim-markdown-preview'
Plug 'junegunn/goyo.vim'
Plug 'tomtom/tcomment_vim'
Plug 'reedes/vim-colors-pencil'
Plug 'tpope/vim-surround'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'nathanaelkane/vim-indent-guides'
Plug 'AndrewRadev/splitjoin.vim'

call  plug#end() 

set runtimepath^=-/.nvim/bundle/ctrlp.vim

let g:tex_conceal = ""
let g:vim_markdown_math = 1

set statusline+=#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_cpp_compiler_options = ' -std=c++11' 
let g:syntastic_cpp_compiler = 'clang++'

let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_experimental_simple_template_highlight = 1

let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1





function! s:goyo_enter()
    colorscheme pencil
endfunction

function! s:goyo_leave()
    colorscheme onedark
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()
