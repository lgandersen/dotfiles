
" Yankring - redefined default keys that conflict with mine
let g:yankring_replace_n_pkey = '<C-m>'
let g:yankring_replace_n_nkey = '<C-o>'

" Toggle highlightinh on/off when searching
nnoremap <F3> :set hlsearch!<CR>

" IRSSI-like behaviour for tabs:
" For some reason <alt-X> (i.e. <M-C> in vim) is messed up with ESC when the signal is parsed from the terminal.
" But it seems to work with the configuration below
map <C-n> :tabn<cr>
map <C-p> :tabp<cr>
" Tab Control (others)
nnoremap <Esc>1 :tabn1<cr>
nnoremap <Esc>2 :tabn2<cr>
nnoremap <Esc>3 :tabn3<cr>
nnoremap <Esc>4 :tabn4<cr>
nnoremap <Esc>5 :tabn5<cr>
nnoremap <Esc>6 :tabn6<cr>
nnoremap <Esc>7 :tabn7<cr>
nnoremap <Esc>8 :tabn8<cr>
nnoremap <Esc>9 :tabn9<cr>
nnoremap <Esc>0 :tabn10<cr>
nnoremap .1 :tabn1<cr>
nnoremap .2 :tabn2<cr>
nnoremap .3 :tabn3<cr>
nnoremap .4 :tabn4<cr>
nnoremap .5 :tabn5<cr>
nnoremap .6 :tabn6<cr>
nnoremap .7 :tabn7<cr>
nnoremap .8 :tabn8<cr>
nnoremap .9 :tabn9<cr>
nnoremap .0 :tabn10<cr>

vmap j gj
vmap k gk
nmap j gj
nmap k gk

" set numbering of lines
set number

" Flake8 ignores:
let g:flake8_ignore="E201,E202,E231,E501,E701"
let g:flake8_max_line_length=99

" Disable folding in markdown highlightinh
let g:vim_markdown_folding_disabled=1

" Enable highlightning on postgres SQL files
au BufNewFile,BufRead *.psql setf psql

" VimErl - disabling error-stuff (syntastic will fix that)
let erlang_show_errors=0

" Fix Ex Command mode switch
nnoremap ø :

" Options for BufExplorer
let g:bufExplorerFindActive=0
let g:bufExplorerSortBy='mru'

" Options for Elixir formatter
let g:mix_format_on_save = 1

filetype on            " enables filetype detection
filetype plugin on     " enables filetype specific plugins

"" NOW WE ARE USING PyFlakes (needs to be installed using e.g. pip)
"let g:pyflakes_prefer_python_version = 3

" Check Python files with flake8 and pylint.
let g:ale_linters = {'python': ['flake8', 'pylint']}
" Fix Python files with autopep8 and yapf.
let g:ale_fixers = {'python': ['autopep8', 'yapf', 'black']}
let g:ale_fix_on_save = 1
let g:ale_python_flake8_options = '--max-line-length=130'

