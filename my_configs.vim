" variables
let g:NERDTreeWinPos = 'left'
set nu
set relativenumber
set shiftwidth=4 smarttab expandtab
set tabstop=4 softtabstop=0
 set autowrite

" vim-plug and setups
call plug#begin('~/.vim_runtime/plugged')
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': 'yarn install --frozen-lockfile'}
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
call plug#end()

" load plugins <Plug>PeepOpen
autocmd! User nvim-treesitter/nvim-treesitter echom 'treesitter loaded'
autocmd! User neoclide/coc.nvim echom 'nvim loaded'
autocmd! User folke/tokyonight.nvim echom 'tokyonight loaded'

" colors
colo tokyonight

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
nnoremap gd <Nop>

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
autocmd filetype * nmap <Leader>f :call CocAction('format') <cr>
autocmd filetype * nmap <silent> gd <Plug>(coc-definition) <cr>
autocmd filetype * nmap <silent> gr <Plug>(coc-references-used) <cr>
autocmd filetype * nmap <leader>gi :call CocAction('organizeImport') <cr>


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
