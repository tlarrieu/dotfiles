" ----------------------------
" Smockey's vimrc
" Designed for dvorak-bepo keyboard
" ---------------------------
"
" Custom functions
" Toggle fold state between closed and opened.
"
" If there is no fold at current line, just moves forward.
" If it is present, reverse it's state.
function! ToggleFold()
  if foldlevel('.') == 0
    normal! l
  else
    if foldclosed('.') < 0
       . foldclose
    else
       . foldopen
    endif
  endif
  echo
endf

" Smart completion
function! Smart_Complete()
  let line = getline('.')                         " current line

  let substr = strpart(line, -1, col('.')+1)      " from the start of the current
                                                  " line to one character right
                                                  " of the cursor
  let substr = matchstr(substr, "[^ \t]*$")       " word till cursor
  if (strlen(substr)==0)                          " nothing to match on empty string
    return "\<tab>"
  endif
  let has_period = match(substr, '\.') != -1      " position of period, if any
  let has_slash = match(substr, '\/') != -1       " position of slash, if any
  if (!has_period && !has_slash)
    return "\<C-X>\<C-P>"                         " existing text matching
  elseif ( has_slash )
    return "\<C-X>\<C-F>"                         " file matching
  else
    return "\<C-X>\<C-O>"                         " plugin matching
  endif
endf

" Pathogen calls
call pathogen#runtime_append_all_bundles()
call pathogen#infect()
call pathogen#helptags()

autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
" autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
" Automatically open nerdtree when starting buffer is empty
" autocmd vimenter * if !argc() | NERDTree | endif

" Color theme and font
set background=dark
colorscheme solarized
set guifont=Inconsolata-dz\ For\ Powerline\ 11.5
" 80 characters limit
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/

" Filetype stuff
set nocompatible
syntax on
filetype indent plugin on

" Line numbering
set number

" Blank character
"set lcs=tab:\→\ ,eol:↵,trail:~,nbsp:¤,extends:>,precedes:<
set lcs=tab:\→\ ,trail:~,nbsp:¤,extends:>,precedes:<
set list

" Indent
set ai "autoindent
set si "smart indent
set tabstop=2
set shiftwidth=2
set expandtab

" Folding
hi FoldColumn guibg=grey78 gui=Bold guifg=DarkBlue
"set foldmethod=syntax
set foldcolumn=0
set foldclose=
set foldmethod=indent
set foldnestmax=10
set foldlevel=100
set fillchars=vert:\|,fold:\ 
set foldminlines=2

" Show matching braces
set showmatch

" Command bar
set cmdheight=1

" Encoding and filetype
set encoding=utf8
set ffs=unix,dos,mac

" GUI options
set guioptions+=ce
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar

" Command completion style
set wildmode=list:longest,list:full
set complete=slf

" Visualbell
set novisualbell

" comportement le de la case lors de la recherche
set ignorecase
set smartcase

set cursorline
set cursorcolumn
set hlsearch
set incsearch

" ----- Powerline -----
if ! has('gui_running')
    set ttimeoutlen=10
    augroup FastEscape
        autocmd!
        au InsertEnter * set timeoutlen=0
        au InsertLeave * set timeoutlen=1000
    augroup END
endif
python from powerline.vim import setup as powerline_setup
python powerline_setup()
python del powerline_setup
set laststatus=2 " Always display the statusline in all windows
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)
let g:Powerline_symbols = 'fancy'

" ----- Keyboard mapping -----
" Search highlighting toggle
noremap h :set hlsearch! hlsearch?<CR>

" {/} -> [ê]
noremap ê /
noremap à /

" Line / Character movements
" {cr} = « left / right »
noremap c h
noremap r l
" {ts} = « up / down »
" Navigates through visual lines instead of normal lines
noremap t gj
noremap s gk

" Cancel last action
noremap b u

" Beginning of the word (forward)
noremap i w
" Beginning of the word (backward)
noremap u ge
" End of the word (backward)
noremap a b

" Center screen on current line
noremap <Return> zz

" Fast cursor movement
map T 5t
map S 5s
map R 5r
map C 5c
" Window movement
map <c-S> <c-y>
map <c-T> <c-e>

" Mode switching
noremap ' .
" Enter command mode
noremap . :
" Exit insert mode
imap .' <esc>
" Enter insert mode (before cursor)
noremap , i
vnoremap , i
" Enter insert mode (after cursor)
noremap é a
" Enter file explorer
" noremap <C-t> :NERDTreeToggle<CR>
" Show tag explorer
noremap <C-l> :TagbarToggle<CR>
" Multiline comment
noremap <C-c> :TComment<CR>
vnoremap <C-c> :TComment<CR>
" Delete word and enter insert mode
noremap DD viwc

" Ruby block finisher
imap <C-CR> <Esc>o

" Custom function mapping
" Smart completion
inoremap <c-space> <c-r>=Smart_Complete()<CR>
" Code folding toggle
noremap <space> :call ToggleFold()<CR>
