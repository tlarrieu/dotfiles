" vim:fdm=marker
" ------------------------------------------------------------------------------
" Smockey's vimrc
" Designed for dvorak-bepo keyboard
" ------------------------------------------------------------------------------
set shell=/bin/bash
let $PAGER=''
let mapleader=","
set notimeout
let g:ruby_path = system('rvm current')
" {{{ ------------------------------------------------------------------- Vundle
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Vundle
Plugin 'gmarik/Vundle.vim'
" File Manipulation
Plugin 'kien/ctrlp.vim'
Plugin 'rking/ag.vim'
Plugin 'skwp/greplace.vim'
" Functionnalities
Plugin 'tpope/vim-dispatch'
" Snippets
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
" Text manipulation
Plugin 'Valloric/YouCompleteMe'
Plugin 'AndrewRadev/switch.vim'
Plugin 'tpope/vim-commentary'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'edsono/vim-matchit'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
" Text objects
Plugin 'kana/vim-textobj-user'
Plugin 'b4winckler/vim-angry'
Plugin 'michaeljsmith/vim-indent-object'
" Plugin 'rhysd/vim-textobj-ruby'
Plugin 'nelstrom/vim-textobj-rubyblock'
Plugin 'wellle/targets.vim'
" Task manager
Plugin 'samsonw/vim-task'
" Undo tree explorer
Plugin 'sjl/gundo.vim'
" List toggler
Plugin 'milkypostman/vim-togglelist'
" Ruby
Plugin 'tpope/vim-endwise'
Plugin 'skalnik/vim-vroom'
Plugin 'vim-ruby/vim-ruby'
Plugin 'Keithbsmiley/rspec.vim'
Plugin 'tpope/vim-rails'
Plugin 't9md/vim-ruby-xmpfilter'
" VCS
Plugin 'tpope/vim-fugitive'
Plugin 'phleet/vim-mercenary'
Plugin 'zeekay/vim-lawrencium'
Plugin 'mhinz/vim-signify'
" Misc languages support
Plugin 'vim-scripts/fish-syntax'
Plugin 'gabrielelana/vim-markdown'
Plugin 'scrooloose/syntastic'
Plugin 'roalddevries/yaml.vim'
Plugin 'lmeijvogel/vim-yaml-helper'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'kchmck/vim-coffee-script'
Bundle 'cakebaker/scss-syntax.vim'
Plugin 'elixir-lang/vim-elixir'
" Good looking
Plugin 'altercation/vim-colors-solarized'
Plugin 'bling/vim-airline'
Plugin 'kshenoy/vim-signature'
Plugin 'vim-scripts/AnsiEsc.vim'
Plugin 'reedes/vim-thematic'
" Color picker
Plugin 'KabbAmine/vCoolor.vim'
" Color Highlighter
Plugin 'chrisbra/Colorizer'

call vundle#end()
filetype on
syntax on
filetype plugin indent on
" }}}
" {{{ --------------------------------------------------------- Custom functions
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

function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction

function! DelTagOfFile(file)
  let fullpath = a:file
  let cwd = getcwd()
  let tagfilename = cwd . "/tags"
  let f = substitute(fullpath, cwd . "/", "", "")
  let f = escape(f, './')
  let cmd = 'sed -i "/' . f . '/d" "' . tagfilename . '"'
  let resp = system(cmd)
endfunction

function! UpdateTags()
  let f = expand("%:p")
  let cwd = getcwd()
  let tagfilename = cwd . "/tags"

  if filereadable(tagfilename)
    let cmd = 'ctags -a -f ' . tagfilename . ' "' . f . '"'
    call DelTagOfFile(f)
    let resp = system(cmd)
  endif
endfunction

" Those 2 functions should be refactored into a single one
function! s:UsageOperator(type)
  let saved_register = @@

  if a:type ==# 'v'
    normal! `<v`>y
  elseif a:type ==# 'char'
    normal! `[v`]y
  else
    return
  endif

  silent execute "Ag! " . shellescape(@@) . " . \| grep -v def"

  let @@ = saved_register
endfunction

function! s:DefinitionOperator(type)
  let saved_register = @@

  if a:type ==# 'v'
    normal! `<v`>y
  elseif a:type ==# 'char'
    normal! `[v`]y
  else
    return
  endif

  silent execute "Ag! " . shellescape('(def (self.)?|class )' . @@) . " ."

  let @@ = saved_register
endfunction

" Highlight all instances of word under cursor, when idle.
" Useful when studying strange source code.
function! AutoHighlightToggle()
  let @/ = ''
  if exists('#auto_highlight')
    au! auto_highlight
    augroup! auto_highlight
    setl updatetime=4000
    echo 'Highlight current word: OFF'
    return 0
  else
    augroup auto_highlight
      au!
      au CursorMoved * let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
    augroup end
    setl updatetime=200
    echo 'Highlight current word: ON'
    return 1
  endif
endfunction

" }}}
" {{{ ------------------------------------------------------------- File Related
augroup vimrc_autocmd
  autocmd!
  autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
  autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
  autocmd FileType ruby set makeprg=ruby\ %
  autocmd BufReadPost *.arb setf ruby
  autocmd FileType hgcommit startinsert!
  autocmd BufReadPost COMMIT_EDITMSG startinsert!
  autocmd BufReadPost index noremap <c-s> :Gcommit<cr>
  autocmd FileType hgcommit,gitcommit setlocal spell
  autocmd FileType vim setlocal foldlevel=10
  autocmd FileType vim setlocal foldmethod=marker
  autocmd FileType vim setlocal foldminlines=1
  autocmd FileType html,eruby setlocal foldlevel=1
  autocmd FileType html setlocal foldmethod=syntax
  autocmd FileType html setlocal foldminlines=1
  autocmd BufReadPost *.yml set ft=yaml
  " Only current splits gets cursor line / column highlighted
  autocmd WinLeave * set nocursorline
  autocmd WinLeave * set nocursorcolumn
  autocmd WinEnter * set cursorline
  autocmd WinEnter * set cursorcolumn
  autocmd BufReadPost * hi! link SignColumn CursorColumn
  autocmd BufEnter * hi! link SignColumn CursorColumn
  "Go to the cursor position before buffer was closed
  autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif"`""'")
  autocmd BufWritePost * call UpdateTags()
  " Don't add the comment prefix when I hit enter or o/O on a comment line.
  autocmd FileType * setlocal formatoptions-=o formatoptions-=r
  " Don't screw up folds when inserting text that might affect them, until
  " leaving insert mode. Foldmethod is local to the window.
  autocmd InsertEnter * let w:last_fdm=&foldmethod | setlocal foldmethod=manual
  autocmd InsertLeave * let &l:foldmethod=w:last_fdm
  autocmd FileType man setlocal foldlevel=10
  autocmd BufReadPost *.clj RainbowParenthesesLoadRound
  autocmd BufReadPost *.clj RainbowParenthesesActivate
  autocmd BufEnter *.clj RainbowParenthesesLoadRound
  autocmd BufEnter *.clj RainbowParenthesesActivate
augroup END
" }}}
" {{{ ---------------------------------------------------------- General options
" Color / background theme
set background=light
colorscheme solarized
if has('gui_running')
  set guifont=Inconsolata\ For\ Powerline:h17.6
  set guioptions-=l
  set guioptions-=L
  set guioptions-=r
  set guioptions-=R
  set guioptions-=b
  set guicursor+=n-v-c-i:ver11-iCursor
  hi! iCursor guifg=white guibg=#667B83
endif
" Line numbering (relative and current)
set rnu
set nu
" Line length warning (disabled for now)
" highlight OverLength ctermbg=red ctermfg=black
" match OverLength /\%81v.\+/
" Virtual editing
set virtualedit=all
" Blank character
set lcs=tab:\›\ ,trail:·,nbsp:¤,extends:❯,precedes:❮
set showbreak=↪
set list
" Show matching braces
set showmatch
" Show command
set showcmd
" Encoding and filetype
set encoding=utf8
set ffs=unix,dos,mac
" Undo, backup and swap files
set undodir=~/.tmp//
set backupdir=~/.tmp//
set directory=~/.tmp//
" Activate undofile, that holds undo history
set undofile
" Ignore those files
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,tags
" Case insensitive matching
set wildignorecase
" ctags
set tags=.tags,./.tags,./tags,tags
" current line / column highlight
set cursorline
set cursorcolumn
" mouse
set mouse=c
" Command completion style
set wildmode=list:full,full
" Only complete to the GCD part of file name
set wildmenu
set complete=slf
" Bells
set visualbell
set noerrorbells
" Allow a modified buffer to be sent to background without saving it
set hidden
" Set title when in console
set title
" Give backspace a reasonable behavior
set backspace=indent,eol,start
" Disable line wrap
set nowrap
" }}}
" {{{ ------------------------------------------------------------------- Splits
hi! link VertSplit CursorColumn
set splitright
set splitbelow
" }}}
" {{{ ---------------------------------------------------------------- Scrolling
set scrolloff=8
let &scrolloff=999-&scrolloff
set sidescrolloff=15
let &sidescrolloff=999-&sidescrolloff
set sidescroll=1
" }}}
" {{{ ------------------------------------------------------------------- Indent
set ai "autoindent
set si "smart indent
set tabstop=2
set shiftwidth=2
set expandtab
set shiftround
" }}}
" {{{ ------------------------------------------------------------------ Folding
set foldcolumn=0
set foldclose=
set foldmethod=indent
set foldnestmax=3
set foldlevelstart=10
set fillchars+=fold: 
set foldminlines=1
function! MyFoldText()
    let line = getline(v:foldstart)

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

    " expand tabs into spaces
    let onetab = strpart('          ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
    return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
endfunction
set foldtext=MyFoldText()
nnoremap <leader>z zMzv
nnoremap zO zczO
" }}}
" {{{ ---------------------------------------------------------------- Searching
" case behavior regarding searching
set ignorecase
set smartcase
" some more search related stuff
set hlsearch  " highlight search
set incsearch " start search while typing
" }}}
" {{{ ------------------------------------------------------------ Spellchecking
set spelllang=en,fr
" }}}
" {{{ ------------------------------------------------------------------ Plugins
" {{{ ------------------------------------- vCoolor
map <leader>c :VCoolor<cr>
map <leader>C :ColorToggle<cr>
" }}}
" {{{ ------------------------------------- endwise
autocmd FileType elixir
      \ let b:endwise_addition = 'end' |
      \ let b:endwise_words = 'do' |
      \ let b:endwise_pattern = '\<do\ze\s*$' |
      \ let b:endwise_syngroups = 'elixirKeyword'
" }}}
" {{{ ----------------------------------- xmpfilter
augroup xmpfilter
  autocmd FileType ruby nmap <buffer> <leader>m <Plug>(xmpfilter-mark)
  autocmd FileType ruby xmap <buffer> <leader>m <Plug>(xmpfilter-mark)
  autocmd FileType ruby imap <buffer> <leader>m <Plug>(xmpfilter-mark)

  autocmd FileType ruby nmap <buffer> <leader>M <Plug>(xmpfilter-run)
  autocmd FileType ruby xmap <buffer> <leader>M <Plug>(xmpfilter-run)
  autocmd FileType ruby imap <buffer> <leader>M <Plug>(xmpfilter-run)
augroup end
" }}}
" {{{ ---------------------------------------- YAML
augroup yaml
  autocmd FileType yaml nmap <buffer> 6 :YamlGoToKey 
  autocmd FileType yaml nmap <buffer> 7 :YamlGoToParent<cr>
  autocmd FileType yaml nmap <buffer> 8 :YamlGetFullPath<cr>
augroup end
" }}}
" {{{ ---------------------------------- ToggleList
 let g:toggle_list_copen_command="Copen"
" }}}
" {{{ ------------------------------------ Thematic
let g:thematic#themes = {
      \ 'solarized_dark' :{'colorscheme': 'solarized',
      \                 'background': 'dark',
      \                 'airline-theme': 'solarized',
      \                 'ruler': 1,
      \                },
      \ 'solarized_lite' :{'colorscheme': 'solarized',
      \                 'background': 'light',
      \                 'airline-theme': 'solarized',
      \                 'ruler': 1,
      \                },
      \ }

" }}}
" {{{ ------------------------------------ Disptach
nmap <leader>d :Dispatch<cr>
nmap <leader>f :<c-u>Focus  %<left><left>
" }}}
" {{{ --------------------------------------- Vroom
let g:vroom_use_dispatch = 1
let g:vroom_use_zeus = 0
let g:vroom_use_colors = 1
let g:vroom_map_keys = 0
augroup auvroom
  autocmd FileType ruby nmap <leader>rs :VroomRunTestFile<cr>
  autocmd FileType ruby nmap <leader>rn :VroomRunNearestTest<cr>
augroup end
" }}}
" {{{ --------------------------------------- Angry
let g:angry_disable_maps = 1
vmap <silent> ac <Plug>AngryOuterPrefix
omap <silent> ac <Plug>AngryOuterPrefix
vmap <silent> ic <Plug>AngryInnerPrefix
omap <silent> ic <Plug>AngryInnerPrefix
vmap <silent> aC <Plug>AngryOuterSuffix
omap <silent> aC <Plug>AngryOuterSuffix
vmap <silent> iC <Plug>AngryInnerSuffix
omap <silent> iC <Plug>AngryInnerSuffix
" }}}
" {{{ ------------------------------------- Targets
let g:targets_pairs = '()b {}é []d <>É'
" }}}
" {{{ ----------------------------------- Syntastic
let g:syntastic_javascript_checkers = ['jsl']
let g:syntastic_javascript_jsl_conf = "~/.jsl.conf"
" }}}
" {{{ -------------------------------------- Switch
augroup switch
  autocmd!
  autocmd FileType ruby let b:switch_custom_definitions =
        \[
        \ {
        \   'lambda { \?|\(.*\)| \(.*\) \?}': '->(\1) { \2 }',
        \   'lambda { \?\(.*\) \?}': '-> { \1 }',
        \   '\(\S\+.\+\).should\(\s\+\)==\s*\(.\+\)': 'expect(\1).to\2eq \3',
        \   '\(\S\+.\+\).should\(\S\+\)\s*\(.\+\)': 'expect(\1).to\2 \3',
        \ }
        \]
augroup END
" nmap -  :Switch<cr>
" }}}
" {{{ ------------------------------------ Greplace
set grepprg=ag
let g:grep_cmd_opts = '--line-numbers --noheading'
nmap <leader>S :Gsearch ""<left>
nmap <leader>G :Greplace<cr>
" }}}
" {{{ ------------------------------------------ Ag
let g:ag_apply_qmappings = 0
let g:ag_apply_lmappings = 0

augroup Ag
  autocmd!
  autocmd BufReadPost quickfix nnoremap <silent> <buffer> <C-t> <C-W><CR><C-W>T
  autocmd BufReadPost quickfix nnoremap <silent> <buffer> <CR> <CR><C-w><C-w>
  autocmd BufReadPost quickfix nnoremap <silent> <buffer> <C-v> <C-W><CR><C-W>H<C-W>b<C-W>J<C-W>t
augroup END

nmap <leader>ag :Ag! ""<left>
nmap <leader>u :set operatorfunc=<SID>UsageOperator<cr>g@
nnoremap yu :set operatorfunc=<SID>UsageOperator<cr>g@iw
vmap <leader>u :<c-u>call <SID>UsageOperator(visualmode())<cr>
nnoremap yd :set operatorfunc=<SID>DefinitionOperator<cr>g@iw
vmap <leader>d :<c-u>call <SID>DefinitionOperator(visualmode())<cr>
" }}}
" {{{ ------------------------------------- VimTask
augroup vimtask
  autocmd!
  autocmd FileType task hi taskKeyword     ctermfg=9 guifg=#96CBFE
  autocmd FileType task hi taskWorkingIcon ctermfg=9 guifg=#FF6C60
  autocmd FileType task hi taskDoneIcon    ctermfg=2 gui=italic guifg=#80A441
  autocmd FileType task hi taskWorkingItem ctermfg=9 guifg=#FF6C60
  autocmd FileType task hi taskDoneItem    ctermfg=2 gui=italic guifg=#80A441
  autocmd FileType task noremap <silent> <buffer> zt :call Toggle_task_status()<cr>
  autocmd FileType task xnoremap <silent> <buffer> zt :call Toggle_task_status()<cr>gv
augroup END
" }}}
" {{{ ----------------------------------- UltiSnips
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsJumpForwardTrigger="<c-t>"
let g:UltiSnipsJumpBackwardTrigger="<c-s>"
noremap <leader>use :UltiSnipsEdit<cr>
" }}}
" {{{ ------------------------------- YouCompleteMe
" I want tab for UltiSnips so I deactivate it for YCM
let g:ycm_key_list_select_completion = []
" }}}
" {{{ ------------------------------------- Airline
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_left_sep = '⮀'
let g:airline_left_alt_sep = '⮁'
let g:airline_right_sep = '⮂'
let g:airline_right_alt_sep = '⮃'
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = '⭤'
let g:airline_symbols.linenr = '⭡'
let g:airline_symbols.paste = 'ρ'

set laststatus=2 " Always display the statusline in all windows
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)
let g:airline_theme = 'solarized'
let g:airline_powerline_fonts = 1
let g:airline_inactive_collapse=0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#tabline#fnamemod = ':t:.'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#fnamecollapse = 1
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline_mode_map = {
    \ '__' : '-',
    \ 'n'  : 'NOR',
    \ 'i'  : 'INS',
    \ 'R'  : 'REP',
    \ 'c'  : 'CHA',
    \ 'v'  : 'VIS',
    \ 'V'  : 'L-VIS',
    \ '' : 'B-VIS',
    \ 's'  : 'SEL',
    \ 'S'  : 'L-SEL',
    \ '' : 'B-SEL',
    \ }
" }}}
" {{{ ------------------------------------ Surround
" I want to rebind some (one in fact) bindings and since I cant unbind
" any at this point, I'll go for the brutal way.
let g:surround_no_mappings=1
nmap ds  <Plug>Dsurround
nmap ls  <Plug>Csurround
nmap ys  <Plug>Ysurround
nmap yS  <Plug>YSurround
nmap yss <Plug>Yssurround
nmap ySs <Plug>YSsurround
nmap ySS <Plug>YSsurround
xmap u   <Plug>VSurround
xmap U   <Plug>VgSurround
" }}}
" {{{ --------------------------------------- CtrlP
" let g:ctrlp_map = '<leader><leader>'
let g:ctrlp_map = '<space>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_switch_buffer = 'Et'
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:20,results:20'
let g:ctrlp_open_new_file = 't'
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor
  " Use ag in CtrlP for listing files. Lightning fast and respects " .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif
nmap <leader>é :CtrlPBufTag<cr>
nmap <leader>É :CtrlPTag<cr>
nmap <leader>b :CtrlPBuffer<cr>
nmap <backspace> :<c-u>CtrlPClearCache<cr>
" }}}
" {{{ --------------------------------------- Gundo
let gundo_map_move_older = "t"
let gundo_map_move_newer = "s"
noremap <leader>gu :GundoToggle<cr>
" }}}
" {{{ ------------------------------------- Signify
let g:signify_vcs_list = [ 'hg', 'git' ]
" }}}
" {{{ ------------------------------------ Fugitive
nmap gb :Gblame<cr>
nmap gd :Gvdiff<cr>
nmap gD :Gdiff<cr>
nmap gw :Gwrite<cr>
nmap gr :Gread<cr>
nmap gC :Gcommit<cr>
nmap gs :Gstatus<cr>
nmap gp :Gpush<cr>
" }}}
" {{{ ---------------------- Mercenary / Lawrencium
nmap hb :HGblame<cr>
nmap hd :HGdiff<cr>
nmap hD :HGdiff ancestor(default,.)<cr>
nmap hh :Hg! 
nmap hc :Hgcommit<cr>
nmap hs :Hgstatus<cr>
nmap hS :Dispatch hg status --rev "::. - ::default"<cr>
nmap hr :Hgrevert!<cr>:e<cr>
" }}}
" }}}
" {{{ ------------------------------------------------- Various keyboard mapping
" {{{ --------------------------------- Exercism.io
nmap <silent> <leader>xf :Dispatch exercism f<cr>
nmap <silent> <leader>xs :Dispatch exercism s %<cr>
" }}}
" {{{ --------------------------------------- Marks
noremap ' `
noremap ` '
" }}}
" {{{ ------------------------------- Splits / Tabs
" Navigating between splits
noremap <tab> <c-w>w
noremap <s-tab> <c-w>W
noremap S gT
sunmap  S
noremap T gt
sunmap  T
" Resize splits
map <Up>    <c-w>+
map <Down>  <c-w>-
map <Left>  <c-w><
map <Right> <c-w>>
map <leader>= <c-w>=
map <leader>% :res<cr>:vertical res<cr>$
" }}}
" {{{ ------------------------------------ Movement
" Beginning / end of the line
inoremap <c-a> <c-o>^
cnoremap <c-a> <home>
inoremap <c-e> <c-o>$
cnoremap <c-e> <end>
" left / right / down (visual line) / up (visual line)
nnoremap c h
nnoremap r l
nnoremap t gj
nnoremap s gk
xnoremap c h
xnoremap r l
xnoremap t gj
xnoremap s gk
nnoremap C ^
vnoremap C ^
nnoremap R $
vnoremap R $
" Quifix list
nnoremap <c-p> :cp<cr>
nnoremap <c-n> :cn<cr>
" Gathering selected lines (or current one if none selected) in one line
noremap <c-l> J
" Split lines
noremap <c-j> i<cr><esc>
" Don't make a # force column zero.
inoremap # X<bs>#
" Fuck you, help.
nnoremap <F1> <c-g>
inoremap <F1> <c-g>
" Paste from system buffer
noremap <leader>p :set paste<cr>o<esc>"+p:set nopaste<cr>
noremap <leader>P :set paste<cr>O<esc>"+p:set nopaste<cr>
noremap <leader>y "+y
nnoremap yf :<c-u>let @+ = expand("%")<cr>:echo 'File name yanked.'<cr>
" Give a more logical behavior to Y
nnoremap Y y$
noremap è t
noremap È T
" }}}
" {{{ ------------------------------ Mode Switching
" Save
nnoremap <leader>s :w<cr>
vnoremap <leader>s <esc>:w<cr>
inoremap <leader>s <esc>:w<cr>
" Normal mode
noremap <return> :
" Empty buffers
" map <leader>b :bufdo bd<cr>
command! B bufdo bd
" Change mode
nnoremap l c
nnoremap L C
onoremap l c
onoremap L C
xnoremap l c
xnoremap L C
" Exit
nnoremap à :q<cr>
nnoremap À :qa<cr>
nnoremap ê :bd<cr>
" Disable annoying mapping
map Q <nop>
map K <nop>
" Reselected pasted lines
nnoremap <leader>V V`]
" Select current line charwise
" nnoremap vv ^v$
" }}}
" {{{ ------------------------------------ Togglers
" Rename file
command! RenameFile :call RenameFile()
command! RF :call RenameFile()
nmap <leader>n :call RenameFile()<cr>
" Quickfix / Location togglers
nmap <silent> <leader>q :call ToggleQuickfixList()<cr>
nmap <silent> <leader>Q :Copen<cr>
nmap <silent> <leader>l :call ToggleLocationList()<cr>
" Toggle highlight current word
nmap <leader>' :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
" Clear search
noremap <silent> H :let @/ = ""<cr>
" Search within visual selection
vmap <c-f> <esc>é\%V
" Replace in visual selection
vmap <c-g> <esc>:%s/\%V
" Toggle line wrap
nmap <leader>w :set wrap!<cr>
nnoremap U :redo<cr>
" Split swap
nmap <leader>e :call SplitSwap()<cr><tab>
" Vertical split
noremap <leader>v :vnew <c-r>=escape(expand("%:p:h"), ' ') . '/'<cr>
" Display lint errors
nmap <leader>E :Errors<cr>
" Uppercase current word
nnoremap <c-g> gUiw
inoremap <c-g> <esc>gUiwea
" }}}
" {{{ ---------------------------- Swap number line
noremap " 1
noremap 1 "
noremap « 2
noremap 2 <<_
vnoremap 2 <gv
noremap » 3
noremap 3 >>_
vnoremap 3 >gv
noremap ( 4
noremap 4 (
noremap ) 5
noremap 5 )
noremap @ 6
noremap 6 @
noremap + 7
noremap 7 +
noremap - 8
noremap 8 :Switch<cr>
noremap / 9
noremap 9 /
noremap * 0
noremap 0 *
noremap é /
" }}}
" {{{ ------------------------------- Quick Editing
" Rails
nmap <leader>av :AV<cr>
nmap <leader>ar :AR<cr>
nmap <leader>es :tabe db/structure.sql<cr>

nmap <leader>ev :tabe $MYVIMRC<cr>
nmap <leader>eg :tabe ~/.gitconfig<cr>
nmap <leader>eh :tabe ~/.hgrc<cr>
nmap <leader>ef :tabe ~/.config/fish/config.fish<cr>
nmap <leader>em :tabe ~/.tmux.conf<cr>
nmap <leader>et :tabe ~/todo.tasks<cr>
nmap <leader>er :tabe ~/release.tasks<cr>
" }}}
" {{{ ---------------------------------------- Zeal
noremap k :!zeal --query "<cword>"&<cr><cr>
" }}}
" {{{ ----------------------------- Repeat f with .
nnoremap <Plug>NextMatch ;
nnoremap <silent> f :<C-u>call repeat#set("\<lt>Plug>NextMatch")<CR>f
nnoremap <silent> F :<C-u>call repeat#set("\<lt>Plug>NextMatch")<CR>F
nnoremap <silent> è :<C-u>call repeat#set("\<lt>Plug>NextMatch")<CR>è
nnoremap <silent> È :<C-u>call repeat#set("\<lt>Plug>NextMatch")<CR>È
" }}}
" }}}
