" global variables
let g:NERDTreeWinPos = 'left'
set nu
set relativenumber
set shiftwidth=4 smarttab expandtab
set tabstop=4 softtabstop=0
set autowrite
set encoding=utf-8
set nobackup
set nowritebackup
set updatetime=300
set signcolumn=yes
" removing shortchuts
nnoremap <SPACE> <Nop>
nnoremap <SPACE>? <Nop>
nnoremap <C-space> <Nop>
nnoremap <SPACE>e <Nop>
nnoremap <Leader>e <Nop>
nnoremap <SPACE>f <Nop>
inoremap <SPACE>p <Nop>
nnoremap gd <Nop>

" vim-plug and setups
call plug#begin('~/.vim_runtime/plugged')
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'nvim-lua/plenary.nvim'
Plug 'folke/todo-comments.nvim'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
" code completion and snippets
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'L3MON4D3/LuaSnip', {'tag': 'v1.2.1', 'do': 'make install_jsregexp'}
Plug 'rafamadriz/friendly-snippets'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'b0o/schemastore.nvim'

call plug#end()


" load lua config
luafile ~/.vim_runtime/my_configs.lua


" load plugins
autocmd! User nvim-treesitter/nvim-treesitter echom 'treesitter loaded'
autocmd! User folke/tokyonight.nvim echom 'tokyonight loaded'
autocmd! User folke/todo-comments.nvim echom 'todo-comments loaded'

" colors
colo tokyonight

" shortchuts
map <Leader>e :NERDTreeToggle <cr>
map <Leader>d :bwipeout <cr>

" gui setup
" Set Editor Font
if exists(':GuiFont')
    " Use GuiFont! to ignore font errors
    GuiFont! CaskaydiaCove Nerd Font:h12:1
endif

" Disable GUI Tabline
if exists(':GuiTabline')
    GuiTabline 0
endif

" Disable GUI Popupmenu
if exists(':GuiPopupmenu')
    GuiPopupmenu 0
endif

" Enable GUI ScrollBar
if exists(':GuiScrollBar')
    GuiScrollBar 1
endif

" vue setup
autocmd! filetype *.vue shiftwidth=2 smarttab expandtab tabstop=2 softtabstop=0
autocmd! filetype *.html shiftwidth=2 smarttab expandtab tabstop=2 softtabstop=0
autocmd! filetype *.js shiftwidth=2 smarttab expandtab tabstop=2 softtabstop=0
autocmd! filetype *.ts shiftwidth=2 smarttab expandtab tabstop=2 softtabstop=0
autocmd! filetype *.css shiftwidth=2 smarttab expandtab tabstop=2 softtabstop=0

autocmd! bufwritepost ~/.vim_runtime/my_configs.lua source ~/.vim_runtime/my_configs.vim
