" Basic Vim settings for usability

" Set leader key to space
let mapleader = " "

" Map 'jk' to exit insert mode
inoremap jk <Esc>

" Leader key mappings for convenience
nnoremap <leader>w :w<CR>         " Save file
nnoremap <leader>x :x<CR>         " Save and quit
nnoremap <leader>q :q<CR>         " Quit without saving
nnoremap <leader>d :%d<CR>        

" Enable line numbers
set number

" Highlight the current line
"set cursorline

" Enable syntax highlighting
syntax on

" Set indentation settings
set tabstop=2          " Number of spaces for a tab
set shiftwidth=2       " Indent size for auto-indenting
set expandtab          " Use spaces instead of tabs
set smartindent        " Auto-indent intelligently

" Enable search settings
set hlsearch           " Highlight search matches
set incsearch          " Incremental search
set ignorecase         " Ignore case in searches...
set smartcase          " ...unless uppercase is used

" Enable mouse support
set mouse=a




set clipboard=

set pastetoggle=<F10>
inoremap <C-v> <F10><C-r>+<F10>

vnoremap <C-c> "+y
vnoremap y "+y

nnoremap :%d "_d
nnoremap %d "_d

nnoremap d "_d
nnoremap D "_D
nnoremap x "_x
nnoremap X "_X



" Better split behavior
set splitbelow         " Horizontal splits open below
set splitright         " Vertical splits open to the right

" Persistent undo
set undofile           " Save undo history to a file

" Disable audible bell
set noerrorbells
"set visualbell

" Basic colorscheme and appearance
set background=dark    " Use colors optimized for dark backgrounds

"colorscheme molokai " Set default colorscheme
colorscheme unokai

let g:molokai_original = 1

" Filetype-specific settings
filetype plugin on
filetype indent on


" Show matching parentheses
set showmatch

" Reduce delay for mappings
set timeoutlen=500

" Remember the last cursor position when reopening a file and center with zz
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g'\"zz" | endif
