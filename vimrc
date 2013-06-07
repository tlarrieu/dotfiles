" -----------------------------------------------------------------------------
" Smockey's vimrc
" Designed for dvorak-bepo keyboard
" -----------------------------------------------------------------------------

" -------------------------------------------------------------------- Pathogen
call pathogen#runtime_append_all_bundles()
call pathogen#infect()
call pathogen#helptags()
" ------------------------------------------------------------ Custom functions
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
  let line = getline('.')                     " current line
  let substr = strpart(line, -1, col('.')+1)  " from the start of the current
                                              " line to one character right
                                              " of the cursor
  let substr = matchstr(substr, "[^ \t]*$")   " word till cursor
  if (strlen(substr)==0)                      " nothing to match on empty string
    return "\<tab>"
  endif
  let has_period = match(substr, '\.') != -1  " position of period, if any
  let has_slash = match(substr, '\/') != -1   " position of slash, if any
  if (!has_period && !has_slash)
    return "\<C-X>\<C-P>"                     " existing text matching
  elseif ( has_slash )
    return "\<C-X>\<C-F>"                     " file matching
  else
    return "\<C-X>\<C-O>"                     " plugin matching
  endif
endf
" ---------------------------------------------------------------- File Related
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
filetype on
filetype plugin on
filetype indent on
syntax on
" -------------------------------------------------------------- General options
" Disable the ugly vi compatibility
set nocompatible
" Color / background theme
set background=dark
colorscheme solarized
" Line numbering (relative to current line)
set relativenumber
" Blank character
set lcs=tab:\→\ ,trail:~,nbsp:¤,extends:>,precedes:<
set list
" Show matching braces
set showmatch
" Encoding and filetype
set encoding=utf8
set ffs=unix,dos,mac
" current line / column highlight
set cursorline
set cursorcolumn
" Command completion style
set wildmode=list:longest,list:full
" Only complete to the GCD part of file name
set wildmenu
set complete=slf
" Visualbell
set novisualbell
set noerrorbells
" A buffer becomes hidden when it is abandoned
set hid
" Set title when in console
set title
" Activate undofile, that holds undo history
set undofile
" ---------------------------------------------------------------------- Indent
set ai "autoindent
set si "smart indent
set tabstop=2
set shiftwidth=2
set expandtab
" --------------------------------------------------------------------- Folding
hi FoldColumn guibg=grey78 gui=Bold guifg=DarkBlue
set foldcolumn=0
set foldclose=
set foldmethod=indent
set foldnestmax=10
set foldlevel=100
set fillchars=vert:\|,fold:\ 
set foldminlines=2
" ----------------------------------------------------------------- GUI options
if has("gui_running")
  set guifont=Inconsolata\ For\ Powerline\ 15
  set guioptions+=ce
  set guioptions-=m  "remove menu bar
  set guioptions-=T  "remove toolbar
  set guioptions-=r  "remove right-hand scroll bar
  set guioptions-=L  "remove left-hand scroll bar
endif
" ------------------------------------------------------------------- Searching
" case behavior regarding searching
set ignorecase
set smartcase
" some more search related stuff
set hlsearch  " highlight search
set incsearch " start search while typing
" ------------------------------------------------------------------- Powerline
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
" ------------------------------------------------------------ Keyboard mapping
let mapleader = "ç" " remapping leader (this is basically the same position as
                    " "\" on qwerty
" A buttload of delimiters insertion around current word (normal mode) or selection
" (visual mode) through leader (this only works
" with my bindings since I remapped "k" for "c" and "é" for "a"
" shall do the trick)
map <leader>" DD""<esc>P`]r
map <leader>< DD<><esc>P`]r
map <leader>' DD''<esc>P`]r
map <leader>( DD()<esc>P`]r
map <leader>[ DD[]<esc>P`]r
vmap <leader>" k""<esc>P`]r
vmap <leader>< k<><esc>P`]r
vmap <leader>' k''<esc>P`]r
vmap <leader>( k()<esc>P`]r
vmap <leader>[ k[]<esc>P`]r
" Delete word and enter insert mode
noremap <leader>d viwc
" ---------------------------------------- Movement
" left
noremap c h
" right
noremap r l
" down (visual line)
noremap t gj
" up (visual line)
noremap s gk
" Cancel last action
noremap b u
" Beginning of the word (forward)
noremap i w
" End of the word (backward)
noremap u ge
" Beginning of the word (backward)
noremap a b
" Beginning of the line
noremap à ^
" Beginning of the line, entering insert mode
noremap À I
" End of the line
noremap f $
" End of the line, entering insert mode
noremap F A
" Center screen on current line
noremap <Return> zz
" Fast cursor movement
map T 5t
map S 5s
map R 5r
map C 5c
" Window movement
noremap <c-S> <c-y> " up
noremap <c-T> <c-e> " down
" Insert new line after current one
" without breaking it
imap <C-CR> <Esc>o
" ---------------------------------- Mode Switching
noremap ' .
" Enter command mode
noremap . :
" Exit insert mode
imap .' <esc>
" Enter insert mode (before cursor)
nnoremap , i
vnoremap , i
" Enter insert mode (after cursor)
noremap é a
" Change mode
noremap k c
" ---------------------------------------- Togglers
" Multi-line comment
noremap <C-c> :TComment<CR>
vnoremap <C-c> :TComment<CR>
" Smart completion
inoremap <c-space> <c-r>=Smart_Complete()<CR>
" Code folding toggle
noremap <space> :call ToggleFold()<CR>
" Search highlighting toggle
noremap h :set hlsearch! hlsearch?<CR>
