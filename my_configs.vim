" global options
nnoremap <SPACE> <Nop>
nnoremap <SPACE>? <Nop>
nnoremap <C-space> <Nop>

" variables
let g:NERDTreeWinPos = 'left'
" colors
colo dracula

" vim-plug and setups
call plug#begin('~/.vim_runtime/plugged')
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': 'yarn install --frozen-lockfile'}
call plug#end()

" load plugins <Plug>PeepOpen
autocmd! User neovim/nvim-lspconfig echom 'lspconfig loaded'
autocmd! User nvim-treesitter/nvim-treesitter echom 'treesitter loaded'
autocmd! User neoclide/coc.nvim echom 'nvim loaded'

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
map <Leader>f :NERDTreeToggle <cr>
