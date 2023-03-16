" variables
let g:NERDTreeWinPos = 'left'
set nu
set relativenumber
" colors

" vim-plug and setups
call plug#begin('~/.vim_runtime/plugged')
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': 'yarn install --frozen-lockfile'}
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
call plug#end()

" load plugins <Plug>PeepOpen
autocmd! User neovim/nvim-lspconfig echom 'lspconfig loaded'
autocmd! User nvim-treesitter/nvim-treesitter echom 'treesitter loaded'
autocmd! User neoclide/coc.nvim echom 'nvim loaded'
autocmd! User fatih/vim-go echom 'vim-go loaded'

" plugin related setup
" coc config
inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
inoremap <silent><expr> <cr> coc#pum#visible() ? coc#_select_confirm() : "\<C-g>u\<CR>"
inoremap <silent><expr> <cr> coc#pum#visible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <cr> coc#pum#visible() && coc#pum#info()['index'] != -1 ? coc#pum#confirm() : "\<C-g>u\<CR>"
" use <tab> to trigger completion and navigate to the next complete item
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
inoremap <silent><expr> <Tab>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
" use <c-space> for trigger completion
inoremap <silent><expr> <c-space> coc#refresh()
" Use <C-@> on vim
inoremap <silent><expr> <c-@> coc#refresh()
inoremap <expr> <Tab> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
inoremap <expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"

" shortchuts
nnoremap <SPACE> <Nop>
nnoremap <SPACE>? <Nop>
nnoremap <C-space> <Nop>
nnoremap <Leader>e <Nop>
nnoremap <Leader>f <Nop>

map <Leader>e :NERDTreeToggle <cr>
autocmd filetype python nmap <Leader>f :call CocAction('format') <cr>

" vim-go related
filetype plugin indent on
set autowrite
" Go syntax highlighting
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_operators = 1
" Auto formatting and importing
let g:go_fmt_autosave = 1
let g:go_fmt_command = "goimports"
" Status line types/signatures
let g:go_auto_type_info = 1
autocmd filetype go setlocal omnifunc=go#complete#Complete
autocmd filetype go nnoremap gd :GoDef <cr>
autocmd filetype go nnoremap <Leader>f :GoFmt <cr>

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
