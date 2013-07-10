" -----------------------------------------------------------------------------
" Smockey's vimrc
" Designed for dvorak-bepo keyboard
" -----------------------------------------------------------------------------

let mapleader="," " remapping leader

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

function! g:ToggleNuMode()
  if(&rnu == 1)
    set nu
  else
    set rnu
  endif
endfunc
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
autocmd FileType gitcommit startinsert!
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
" Scrolling
set scrolloff=8
set sidescrolloff=15
set sidescroll=1
" ---------------------------------------------------------------------- Indent
set ai "autoindent
set si "smart indent
set tabstop=2
set shiftwidth=2
autocmd BufRead,BufNewFile *.py setlocal expandtab
" --------------------------------------------------------------------- Folding
hi FoldColumn guibg=grey78 gui=Bold guifg=DarkBlue
set foldcolumn=0
set foldclose=
set foldmethod=indent
set foldnestmax=10
set foldlevel=100
set fillchars=vert:\|,fold:\ 
set foldminlines=2
" ------------------------------------------------------------------- Searching
" case behavior regarding searching
set ignorecase
set smartcase
" some more search related stuff
set hlsearch  " highlight search
set incsearch " start search while typing
" --------------------------------------------------------------------- Plugins
"
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
" ------------------------------------------- RSpec
let g:RspecKeymap=0
" ------------------------------------------------------------ Keyboard mapping

" ------------------------------------------- CtrlP
noremap  <Leader><Leader> :CtrlPMixed<CR>
noremap  <Leader>b        :CtrlPBuffer<CR>
" ----------------------------------------- Tabular
noremap  <Leader>aa :Tabularize /
vnoremap <Leader>aa :Tabularize /
noremap  <Leader>a= :Tabularize /=<CR>
vnoremap <Leader>a= :Tabularize /=<CR>
" ---------------------------------------- Fugitive
noremap <Leader>gb :Gblame<CR>
noremap <Leader>gd :Gdiff<CR>
noremap <Leader>gw :Gwrite<CR>
noremap <Leader>gr :Gread<CR>
noremap <Leader>gc :Gcommit<CR>
noremap <Leader>gs :Gstatus<CR>
" ------------------------------------------- RSpec
autocmd BufRead,BufNewFile * noremap <Leader>tt :RerunSpec<CR>
autocmd BufRead,BufNewFile *_spec.rb noremap <Leader>tt :RunSpec<CR>
autocmd BufRead,BufNewFile *_spec.rb noremap <Leader>tl :RunSpecLine<CR>
autocmd BufRead,BufNewFile *_spec.rb noremap <Leader>tr :RerunSpec<CR>
" ---------------------------------------- Surround
nmap <Leader>ds  <Plug>Dsurround
" I'm using « c » as « h » since I'm in bépo layout, so I need to change this
nmap <Leader>ks  <Plug>Csurround
nmap <Leader>is  <Plug>Ysurround
nmap <Leader>iS  <Plug>YSurround
nmap <Leader>iss <Plug>Yssurround
nmap <Leader>iSs <Plug>YSsurround
nmap <Leader>iSS <Plug>YSsurround
vmap <Leader>s   <Plug>VSurround
vmap <Leader>S  <Plug>VgSurround
" ------------------------ System yanking / pasting
noremap  <Leader>y "+yy
vnoremap <Leader>y "+y
noremap  <Leader>p "+p
" ------------------------------------------ Search
noremap « #
noremap » *
" ------------------------------------------- Marks
noremap ' `
noremap ` '
" ------------------------------------------ Splits
" Navigating between splits
noremap <S-s>  <C-w>k
noremap <S-t>  <C-w>j
noremap <S-c>  <C-w>h
noremap <S-r>  <C-w>l
" Creating new splits
noremap <Leader>v :vnew<Space>
noremap <Leader>V <C-w>v
noremap <Leader>h :new<Space>
noremap <Leader>H <C-w>s
" -------------------------------------------- Tabs
" Navigating between tabs
map <Leader>c :tabp<CR>
map <Leader>r :tabn<CR>
map <Leader>' :tabnew 
" ---------------------------------------- Sessions
map <Leader>ss :mksession! 
map <Leader>sl :source 
" ---------------------------------------- Movement
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
" left / right / down (visual line) / up (visual line)
noremap c h
noremap r l
noremap t gj
noremap s gk
" move current line up or down
noremap <C-up>   :m-2<CR>
noremap <C-down> :m+<CR>
" Insert new line after current one without breaking it
inoremap <C-cr> <Esc>o
noremap  <C-cr> m`o<Esc>``
" Same but before current one
inoremap <S-cr> <Esc>O
noremap  <S-cr> m`O<Esc>``
" Gathering selected lines (or current one if none selected) in one line
noremap <C-l> J
" visual shifting (builtin-repeat)
nnoremap <Tab>   >>_
nnoremap <S-Tab> <<_
inoremap <S-Tab> <C-D>
vnoremap <Tab>   >gv
vnoremap <S-Tab> <gv
" Don't make a # force column zero.
inoremap # X<BS>#
" ---------------------------------- Mode Switching
noremap  <C-c> <esc>
inoremap <C-c> <esc>
onoremap <C-c> <esc>
vnoremap <C-c> <esc>
" Save
noremap  <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>
vnoremap <C-s> <Esc>:w<CR>
" Command mode
noremap  <C-t> :
vnoremap <C-t> :
inoremap <C-t> <Esc>:
" Change mode
noremap k c
" Help
noremap  <C-h> :h<Space>
vnoremap <C-h> <Esc>:h<Space>
inoremap <C-h> <Esc>:h<Space>
" Edit
noremap  <C-e> :e<Space>
vnoremap <C-e> <Esc>:e<Space>
inoremap <C-e> <Esc>:e<Space>
" Exit
noremap <Leader>q :q<CR>
noremap <Leader>Q :qa<CR>
" ---------------------------------------- Togglers
" Smart completion
inoremap <C-Space> <c-r>=Smart_Complete()<CR>
" Code folding toggle
noremap <Space> :call ToggleFold()<CR>
" Swap 2 splits (only works within the same tab)
noremap <Leader>e :call SplitSwap()<CR>
" Search highlighting toggle
" noremap h :set hlsearch! hlsearch?<CR>
" Clear search
noremap <silent> h :let @/ = ""<CR>
" Toggle absolute / relative numbering
noremap <Leader>n :call g:ToggleNuMode()<CR>
" Toggle line wrap
noremap <Leader>w :set wrap!<CR>
