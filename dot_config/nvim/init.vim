call plug#begin(expand('~/.config/nvim/plugged'))

" Plugins
Plug 'vim-airline/vim-airline' " Bottom bar
Plug 'vim-airline/vim-airline-themes' " Themes for the bottom bar
Plug 'neoclide/coc.nvim', {'branch': 'release'} " Completion popup
Plug 'tpope/vim-sensible' " Sensible defaults
Plug 'airblade/vim-gitgutter' " Show git diff
Plug 'editorconfig/editorconfig-vim' " Editorconfig support
Plug 'mattn/emmet-vim' " Emmet support (e.g. lorem10)
Plug 'pechorin/any-jump.vim' " Find definitions/references/usages
Plug 'sheerun/vim-polyglot' " Language packs
Plug 'skanehira/denops-docker.vim' " Docker support
Plug 'arcticicestudio/nord-vim' " Nord color scheme
Plug 'kyazdani42/nvim-web-devicons' " File icons
Plug 'kyazdani42/nvim-tree.lua' " File tree
Plug 'romgrk/barbar.nvim' " File tabs
Plug 'elkowar/yuck.vim' " Yuck support (for eww)

call plug#end()

let g:airline_powerline_fonts = 1

colorscheme nord

set number
set linebreak
set showbreak=+++
set textwidth=100
set showmatch

set hlsearch
set smartcase
set ignorecase
set incsearch

set autoindent
set expandtab
set shiftwidth=2
set smartindent
set smarttab
set softtabstop=2
set mouse=a

set ruler
set noshowmode

set undolevels=1000
set backspace=indent,eol,start

filetype plugin on
syntax on

" Initialise file tree
:lua require("nvim-tree").setup()

" Bind Ctrl+T to focus file tree
nnoremap <C-t> :NvimTreeFocus<CR>

" Revert the cursor to beam when exiting
au VimLeave * set guicursor=a:ver100-iCursor
