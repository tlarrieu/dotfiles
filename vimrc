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

" This is a really handy function!
" Basically, the Shell command will prompt the result of any out command
" into a new split.
command! -complete=shellcmd -nargs=+ Shell call s:RunShellCommand(<q-args>)
function! s:RunShellCommand(cmdline)
  echo a:cmdline
  let expanded_cmdline = a:cmdline
  for part in split(a:cmdline, ' ')
     if part[0] =~ '\v[%#<]'
        let expanded_part = fnameescape(expand(part))
        let expanded_cmdline = substitute(expanded_cmdline, part, expanded_part, '')
     endif
  endfor
  botright new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  call setline(1, 'You entered:    ' . a:cmdline)
  call setline(2, 'Expanded Form:  ' .expanded_cmdline)
  call setline(3,substitute(getline(2),'.','=','g'))
  execute '$read !'. expanded_cmdline
  setlocal nomodifiable
  1
endfunction

function! MarkSplitSwap()
  let g:markedWinNum = winnr()
endfunction

function! DoSplitSwap()
  "Mark destination
  let curNum = winnr()
  let curBuf = bufnr( "%" )
  exe g:markedWinNum . "wincmd w"
  "Switch to source and shuffle dest->source
  let markedBuf = bufnr( "%" )
  "Hide and open so that we aren't prompted and keep history
  exe 'hide buf' curBuf
  "Switch to dest and shuffle source->dest
  exe curNum . "wincmd w"
  "Hide and open so that we aren't prompted and keep history
  exe 'hide buf' markedBuf 
endfunction

function! SplitSwap()
  if exists("g:markedWinNum")
    silent call DoSplitSwap()
    unlet g:markedWinNum
  else
    silent call MarkSplitSwap()
  end
endfunction

" ---------------------------------------------------------------- File Related
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
filetype on
filetype plugin on
filetype indent on
syntax on
" A few completion related stuff
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType ruby set omnifunc=rubycomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete

" Only current splits gets cursor line / column highlighted
autocmd WinLeave * set nocursorline
autocmd WinLeave * set nocursorcolumn
autocmd WinEnter * set cursorline
autocmd WinEnter * set cursorcolumn
" Automatically goes to the directory where the edited file is located
" I added a try / catch there to handle fugitive that does not allow this
" (since there is an 'incorrect' path related to it
" autocmd BufEnter * execute 'try | lcd %:p:h | catch | | endtry'
"Go to the cursor position before buffer was closed
autocmd BufReadPost * normal g'"
autocmd BufReadPost *.md set ft=markdown

au BufWritePost *.coffee silent CoffeeMake!
" -------------------------------------------------------------- General options
" Disable the ugly vi compatibility
set nocompatible
" Color / background theme
set background=dark
colorscheme solarized
" Line numbering (relative to current line)
set relativenumber
" Blank character
set lcs=tab:\›\ ,trail:~,nbsp:¤,extends:>,precedes:<
set list
" Show matching braces
set showmatch
" Show command
set showcmd
" Encoding and filetype
set encoding=utf8
set ffs=unix,dos,mac
" Ignore those files
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc
" current line / column highlight
set cursorline
set cursorcolumn
" Command completion style
set wildmode=list:longest,list:full
" Only complete to the GCD part of file name
set wildmenu
set complete=slf
" Disable any kind of annoying bell
set novisualbell
set noerrorbells
" Allow a modified buffer to be sent to background without saving it
set hidden
" Set title when in console
set title
" Activate undofile, that holds undo history
set undofile
" Give backspace a reasonable behavior
set backspace=indent,eol,start
set splitright
set splitbelow
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
  set guifont=Inconsolata\ For\ Powerline\ 13
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
" --------------------------------------------------------------------- Plugins
" --------------------------------------- Powerline
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
" ---------------------------------------- Surround
" I want to rebind some (one in fact) bindings and since I cant unbind
" any at this point, I'll go for the brutal way.
let g:surround_no_mappings=1
" ------------------------------------------------------------ Keyboard mapping
let mapleader = "," " remapping leader

" CtrlP binding
noremap  <leader>, :CtrlPMixed<cr>

" System yanking / pasting
noremap  <leader>y "+yy
vnoremap <leader>y "+y
noremap  <leader>p "+p

" Custom shell commands
noremap <leader>s :silent Shell 
noremap <leader>S :Shell 
noremap <leader>m :silent Shell pylint % <cr>

" Tabular bindings
noremap  <leader>tt :Tabularize /
vnoremap <leader>tt :Tabularize /
noremap  <leader>t= :Tabularize /=<cr>
vnoremap <leader>t= :Tabularize /=<cr>
noremap  <leader>t: :Tabularize /:<cr>
vnoremap <leader>t: :Tabularize /:<cr>

" Fugitive bindings
noremap <leader>gb :Gblame<cr>
noremap <leader>gd :Gdiff<cr>
noremap <leader>gw :Gwrite<cr>
noremap <leader>gr :Gread<cr>
noremap <leader>gc :Gcommit<cr>
noremap <leader>gl :silent Shell git log<cr>
" ---------------------------------------- Surround
nmap ds  <Plug>Dsurround
" I'm using « c » as « h » since I'm in bépo layout, so I need to change this
nmap ks  <Plug>Csurround
nmap ys  <Plug>Ysurround
nmap yS  <Plug>YSurround
nmap yss <Plug>Yssurround
nmap ySs <Plug>YSsurround
nmap ySS <Plug>YSsurround
xmap S   <Plug>VSurround
xmap gS  <Plug>VgSurround
" ------------------------------------------ Search
noremap « #
noremap » *
" ---------------------------------------- Movement
" left / right / down (visual line) / up (visual line)
noremap c h
noremap r l
noremap t gj
noremap s gk
" Navigating between splits
noremap <up>    <C-w>k
noremap <down>  <C-w>j
noremap <left>  <C-w>h
noremap <right> <C-w>l
" Navigating between tabs
map <C-left>  :tabp<cr>
map <C-right> :tabn<cr>
" Beginning of the line
noremap à ^
" End of the line
noremap f $
" Fast cursor movement
map T 5t
map S 5s
map R 5r
map C 5c
" move current line up or down
noremap <c-up>   :m-2<cr>
noremap <c-down> :m+<cr>
" Insert new line after current one without breaking it
inoremap <c-cr> <Esc>o
" Same but before current one
inoremap <s-cr> <Esc>O
" Gathering selected lines (or current one if none selected)
" in one line
noremap <C-l> J
" visual shifting (builtin-repeat)
nnoremap <Tab> >>_
nnoremap <S-Tab> <<_
inoremap <S-Tab> <C-D>
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv
" ---------------------------------- Mode Switching
" Command mode
noremap  <c-t> :
vnoremap <c-t> :
inoremap <c-t> <esc>:
" Change mode
noremap k c
" Save file
inoremap <c-s> <esc>:w<cr>
noremap  <c-s> :w<cr>
" Quit file 
noremap  <c-q> :q<cr>
inoremap <c-q> <esc>:q<cr>
vnoremap <c-q> <esc>:q<cr>
" Save and quit
noremap  <c-x> :x<cr>
inoremap <c-x> <esc>:x<cr>
vnoremap <c-x> <esc>:x<cr>
" Help
noremap  <c-h> :h 
vnoremap <c-h> <esc>:h 
inoremap <c-h> <esc>:h 
" ---------------------------------------- Togglers
" Multi-line comment
noremap  <C-c> :TComment<CR>
vnoremap <C-c> :TComment<CR>
" Smart completion
inoremap <c-space> <c-r>=Smart_Complete()<CR>
" Code folding toggle
noremap <space> :call ToggleFold()<CR>
" Swap 2 splits (only works within the same tab)
noremap <leader>e :call SplitSwap()<cr>
" Search highlighting toggle
" noremap h :set hlsearch! hlsearch?<CR>
" Clear search
noremap <silent> h :let @/ = ""<cr>
" Handy trick that clears previous search and starts a new one (forcing
" highlighting on the way
noremap / :let @/ = ""<cr>:set hlsearch<cr>/
