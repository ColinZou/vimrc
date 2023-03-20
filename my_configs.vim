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
nnoremap <Leader>e <Nop>
nnoremap <Leader>f <Nop>
inoremap <SPACE>p <Nop>
inoremap <Leader>p <Nop>
nnoremap gd <Nop>

" coc-plugins
let g:coc_global_extensions = ['coc-json', 'coc-yaml', 'coc-pyright', 'coc-go']

" vim-plug and setups
call plug#begin('~/.vim_runtime/plugged')
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': 'yarn install --frozen-lockfile'}
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'nvim-lua/plenary.nvim'
Plug 'folke/todo-comments.nvim'
call plug#end()

" load plugins <Plug>PeepOpen
autocmd! User nvim-treesitter/nvim-treesitter echom 'treesitter loaded'
autocmd! User neoclide/coc.nvim echom 'nvim loaded'
autocmd! User folke/tokyonight.nvim echom 'tokyonight loaded'
autocmd! User folke/todo-comments.nvim echom 'todo-comments loaded'

" colors
colo tokyonight

" plugin related setup
" coc config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
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
" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif
" Use <C-@> on vim
inoremap <silent><expr> <c-@> coc#refresh()
inoremap <expr> <Tab> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
inoremap <expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"
" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>

" shortchuts
map <Leader>e :NERDTreeToggle <cr>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

nnoremap <silent> K :call <SID>show_documentation()<CR>

" coc related
nmap <Leader>f :call CocAction('format') <cr>
nmap <silent> gd <Plug>(coc-definition) <cr>
nmap <silent> gr <Plug>(coc-references-used) <cr>
nmap <leader>gi :call CocAction('organizeImport') <cr>
" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

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
