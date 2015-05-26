" vim:fdm=marker
" ------------------------------------------------------------------------------
" tlarrieu's vimrc
" Designed for dvorak-bépo keyboard
" ------------------------------------------------------------------------------
set shell=/bin/bash
let $PAGER=''
let g:ruby_path = system('rvm current')
" {{{ ==| vim-plug |============================================================
set nocompatible

call plug#begin('~/.vim/plugged')

" {{{ --| File Manipulation |--------------
Plug 'kien/ctrlp.vim'
Plug 'rking/ag.vim'
Plug 'skwp/greplace.vim', { 'on' : [ 'Greplace', 'Gqfopen' ] }
Plug 'duggiefresh/vim-easydir'
" }}}
" {{{ --| Functionnalities |---------------
Plug 'tpope/vim-dispatch'
Plug 'beloglazov/vim-online-thesaurus'
Plug 'tpope/vim-vinegar'
Plug 'AndrewRadev/linediff.vim'
" }}}
" {{{ --| Snippets |-----------------------
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
" }}}
" {{{ --| Project config |-----------------
Plug 'tpope/vim-projectionist'
" }}}
" {{{ --| Text manipulation |--------------
Plug 'AndrewRadev/switch.vim'
Plug 'tpope/vim-commentary'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'edsono/vim-matchit'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'godlygeek/tabular'
" }}}
" {{{ --| Text objects |-------------------
Plug 'kana/vim-textobj-user'
Plug 'michaeljsmith/vim-indent-object'
Plug 'nelstrom/vim-textobj-rubyblock',
      \ { 'for' : [ 'ruby', 'eruby', 'rspec', 'rake' ] }
Plug 'wellle/targets.vim'
Plug 'tommcdo/vim-exchange'
Plug 'kana/vim-textobj-function'
" }}}
" {{{ --| Task manager |-------------------
Plug 'samsonw/vim-task', { 'for' : [ 'task', 'tasks' ] }
" }}}
" {{{ --| Undo tree explorer |-------------
" Plug 'sjl/gundo.vim'
" }}}
" {{{ --| List toggler |-------------------
Plug 'milkypostman/vim-togglelist'
" }}}
" {{{ --| Ruby |---------------------------
Plug 'janko-m/vim-test'
Plug 'vim-ruby/vim-ruby', { 'for' : 'ruby' }
Plug 'Keithbsmiley/rspec.vim', { 'for' : 'ruby' }
Plug 'jbgutierrez/vim-partial'
Plug 'tpope/vim-rails'
" }}}
" {{{ --| HTML |---------------------------
Plug 'mattn/emmet-vim', { 'for' : [ 'html', 'eruby', 'sass', 'css'] }
" }}}
" {{{ --| Haskell |------------------------
Plug 'twinside/vim-syntax-haskell-cabal', { 'for' : 'haskell' }
Plug 'bitc/vim-hdevtools', { 'for' : 'haskell' }
" }}}
" {{{ --| Go lang |------------------------
Plug 'fatih/vim-go', { 'for' : 'go' }
" }}}
" {{{ --| SQL |----------------------------
Plug 'ivalkeen/vim-simpledb', { 'for' : 'sql' }
Plug 'krisajenkins/vim-postgresql-syntax'
" }}}
" {{{ --| Markdown |-----------------------
Plug 'gabrielelana/vim-markdown', { 'for' : 'markdown' }
Plug 'greyblake/vim-preview', { 'for' : 'markdown' }
" }}}
" {{{ --| Misc languages support |---------
Plug 'vim-scripts/fish-syntax', { 'for' : 'fish' }
Plug 'roalddevries/yaml.vim', { 'for' : 'yaml' }
Plug 'lmeijvogel/vim-yaml-helper', { 'for' : 'yaml' }
Plug 'jelera/vim-javascript-syntax', { 'for' : 'javascript' }
Plug 'kchmck/vim-coffee-script', { 'for' : 'coffee' }
Plug 'chrisbra/csv.vim', { 'for' : 'csv' }
Plug 'alfredodeza/jacinto.vim', { 'for' : 'json' }
Plug 'leshill/vim-json', { 'for' : 'json' }
Plug 'lambdatoast/elm.vim', { 'for' : 'elm' }
" }}}
" {{{ --| VCS |----------------------------
Plug 'tpope/vim-fugitive'
Plug 'phleet/vim-mercenary'
Plug 'zeekay/vim-lawrencium'
Plug 'mhinz/vim-signify'
" }}}
" {{{ --| Syntax checking |----------------
Plug 'scrooloose/syntastic'
" }}}
" {{{ --| Good looking |-------------------
Plug 'altercation/vim-colors-solarized'
Plug 'gcmt/taboo.vim'
Plug 'kshenoy/vim-signature'
Plug 'sjl/vitality.vim'
" }}}
" {{{ --| Colors |-------------------------
Plug 'KabbAmine/vCoolor.vim'              " Picker
Plug 'chrisbra/Colorizer'                 " Highlighter
" }}}

call plug#end()

filetype on
syntax on
filetype plugin indent on
" }}}
" {{{ ==| File Related |========================================================
augroup vimrc_autocmd
  autocmd!
  autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
  autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
  autocmd FileType ruby set makeprg=ruby\ %
  autocmd BufReadPost *.arb setf ruby
  autocmd BufReadPost COMMIT_EDITMSG startinsert!
  autocmd FileType html,eruby setlocal foldlevel=10
  autocmd FileType html setlocal foldmethod=syntax
  autocmd FileType html setlocal foldminlines=1
  autocmd BufReadPost *.yml set ft=yaml
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
augroup END

augroup NoSimultaneousEdits
  autocmd!
  autocmd SwapExists * let v:swapchoice = 'o'
  autocmd SwapExists * echomsg 'Duplicate edit session (readonly)'
  autocmd SwapExists * echohl None
  autocmd SwapExists * sleep 1
augroup END
" }}}
" {{{ ==| General options |=====================================================
let mapleader="\<space>"
" Avoiding moving cursor when hitting <space> followed by nothing
map <space> <nop>
" Timeout
set ttimeout
set ttimeoutlen=100
" History
set history=500
" Color / background theme
set background=light
colorscheme solarized
if has('gui_running')
  set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h16
  set guioptions-=l
  set guioptions-=L
  set guioptions-=r
  set guioptions-=R
  set guioptions-=b
  set guioptions-=T
  set guioptions-=m

  " mode aware cursors
  set guicursor+=o:hor50-Cursor
  set guicursor-=n:NormalCursor
  set guicursor+=i-ci-sm:InsertCursor
  set guicursor+=r-cr:ReplaceCursor-hor20
  set guicursor+=c:CommandCursor
  set guicursor+=v-ve:VisualCursor
  set guicursor+=a:blinkon0

  highlight! NormalCursor  term=reverse cterm=reverse
        \ gui=reverse guifg=#93a1a1 guibg=#fdf6e3
  highlight! InsertCursor  ctermfg=15 guifg=#fdf6e3 ctermbg=37  guibg=#2aa198
  highlight! VisualCursor  term=reverse gui=reverse guifg=#268bd2
  highlight! ReplaceCursor ctermfg=15 guifg=#fdf6e3 ctermbg=65  guibg=#d33682
  highlight! CommandCursor term=standout cterm=reverse ctermfg=5 ctermbg=7
        \ gui=standout guifg=#d33682
elseif &term =~ "xterm\\|rxvt"
  let &t_SI = "\<Esc>]12;#268bd2\x7" " Insert mode
  let &t_EI = "\<Esc>]12;#93a1a1\x7" " Normal mode
endif

highlight! Visual ctermfg=7 ctermbg=14
      \ gui=bold guifg=#93a1a1 guibg=#eee8d5 guisp=#268bd2

highlight! link SignColumn LineNr
highlight! CursorLineNr ctermfg=4 ctermbg=7
" Line numbering (relative and current)
set relativenumber
set number
" Line length warning
highlight OverLength ctermbg=red ctermfg=black guibg=red guifg=black
augroup overlength
  autocmd!
  autocmd BufReadPost * match OverLength /\%81v.\+/
  autocmd FileType man highlight! link OverLength Normal
augroup END
" Virtual editing
set virtualedit=all
" Blank character
set lcs=tab:\›\ ,trail:·,nbsp:¬,extends:»,precedes:«
" Display blank characters
set list
" Show matching braces
set showmatch
" Show incomplete key sequence in bottom corner
set showcmd
" Encoding and filetype
set encoding=utf8
set fileformats=unix,dos,mac
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
" mouse
set mouse=c
" Command completion style
set wildmode=list:full,full
" Only complete to the GCD part of file name
set wildmenu
" set complete=slf
set complete=.,w,b,u,t,i
" Bells
set novisualbell
set noerrorbells
" Allow a modified buffer to be sent to background without saving it
set hidden
" Set title when in console
set title
" Give backspace a reasonable behavior
set backspace=indent,eol,start
" Disable line wrap
set nowrap
" Line wrap at word boundaries
set linebreak
" Indent soft-wrapped lines
set breakindent
" Define character indicating line wrap
set showbreak=↪\ 
" Do not insert spaces after '.', '?' and '!' when joining lines
set nojoinspaces
" Do not redraw screen while running macros
set lazyredraw
" Improve redrawing
set ttyfast
" }}}
" {{{ ==| Splits |==============================================================
highlight! link VertSplit CursorColumn
set splitright
set splitbelow
set fillchars+=vert:\ 
" }}}
" {{{ ==| Scrolling |===========================================================
set scrolloff=8
let &scrolloff=999-&scrolloff
set sidescrolloff=15
set sidescroll=1
" }}}
" {{{ ==| Indent |==============================================================
set autoindent
set smartindent
set tabstop=2
set shiftwidth=2
set expandtab
set shiftround
" }}}
" {{{ ==| Folding |=============================================================
set foldcolumn=0
set foldclose=
set foldmethod=indent
set foldnestmax=3
set foldlevelstart=10
set fillchars+=fold: 
set foldminlines=1
set foldtext=FoldText()
nmap <leader>z zMzv
nnoremap zO zczO
" }}}
" {{{ ==| Searching |===========================================================
" case behavior regarding searching
set ignorecase
set smartcase
" some more search related stuff
set hlsearch  " highlight search
set incsearch " start search while typing
highlight! Search ctermbg=7 ctermfg=2 guifg=#719e07
highlight! IncSearch ctermbg=7 ctermfg=5 guifg=#d33682
highlight! IncSearchMatch
      \ ctermbg=7 ctermfg=5 cterm=reverse guibg=#d33682 guifg=#ffffff
" }}}
" {{{ ==| Spellchecking |=======================================================
set spelllang=en,fr
" }}}
" {{{ ==| Status / Tab line |===================================================
set showtabline=2 " Always display tabline
set laststatus=2  " Always display statusline
set noshowmode

function! Highlight()
  highlight! StatusLine  ctermfg=32 guifg=#fdf6e3 ctermbg=15 guibg=#2aa198
  highlight! TabLineSel  ctermfg=15 guifg=#fdf6e3 ctermbg=32 guibg=#2aa198
  highlight! WarningMsg  ctermfg=15 guifg=#fdf6e3 ctermbg=32 guibg=#2aa198

  " Modified file marker (active window)
  highlight! User1 term=bold cterm=bold ctermfg=1 ctermbg=32
  " Modified file marker (inactive window)
  highlight! User4 term=bold cterm=bold ctermfg=1 ctermbg=7
  " Filename
  highlight! User2 ctermfg=15 ctermbg=32
  " VCS Branch
  highlight! User3 ctermfg=15 ctermbg=32
endfunc

function! NoHighlight()
  highlight! WarningMsg   ctermfg=1 ctermbg=7 guifg=Red
  highlight! StatusLine   ctermbg=12 ctermfg=7 guifg=Blue
  highlight! StatusLineNC ctermbg=14 ctermfg=7 guifg=Brown
  highlight! TabLine      term=NONE cterm=NONE ctermfg=12 ctermbg=7 guifg=Blue
  highlight! TabLineFill  term=NONE cterm=NONE ctermfg=12 ctermbg=7 guifg=Blue
  highlight! TabLineSel   term=bold cterm=bold ctermfg=32 ctermbg=7 guifg=Blue

  " Modified file marker (active window)
  highlight! User1 term=bold cterm=bold ctermfg=1 ctermbg=7
  " Modified file marker (inactive window)
  highlight! link User4 User1
  " Filename
  highlight! User2 term=bold cterm=bold ctermfg=14 ctermbg=7
  " VCS Branch
  highlight! User3 ctermfg=14 ctermbg=7
endfunc

function! Paste()
  if &paste
    return ' ⌘ '
  endif
  return ''
endfunction

function! RO()
  if &ro
    return ' ⭤ '
  end
  return ''
endfunction

function! Modified()
  if &modified
    return ' ∙'
  endif
  return ''
endfunction

function! VCSBranch()
  let branch = ''
  let branch = lawrencium#statusline() . fugitive#head()

  if empty(branch)
    return branch
  end

  return ' ⭠ ' . branch . ' '
endfunction

function! Syntastic()
  let syntastic = SyntasticStatuslineFlag()
  if empty(syntastic)
    return ''
  endif
  return ' ' . syntastic
endfunction

let g:whitespace_symbol = ' ⌫ '
let g:whitespace_default_checks = ['indent', 'trailing']
let g:whitespace_trailing_format = 'trailing[%s]'
let g:whitespace_mixed_indent_format = 'mixed-indent[%s]'
let g:whitespace_indent_algo = 1
let g:whitespace_max_lines = 3000

function! CheckMixedIndent()
  if g:whitespace_indent_algo == 1
    " [<tab>]<space><tab>
    " spaces before or between tabs are not allowed
    let t_s_t = '(^\t* +\t\s*\S)'
    " <tab>(<space> x count)
    " count of spaces at the end of tabs should be less then tabstop value
    let t_l_s = '(^\t+ {' . &ts . ',}' . '\S)'
    return search('\v' . t_s_t . '|' . t_l_s, 'nw')
  else
    return search('\v(^\t+ +)|(^ +\t+)', 'nw')
  endif
endfunction

function! Whitespace()
  if &readonly || !&modifiable || line('$') > g:whitespace_max_lines
    return ''
  endif

  if !exists('b:whitespace_check')
    let checks = g:whitespace_default_checks
    let trailing = 0
    let mixed = 0

    if index(checks, 'trailing') > -1
      " Matches " $" but not "\ $" (where $ marks the end of the line)
      " We do not want to match escaped spaces
      let trailing = search('[^.\\]\s$', 'nw')
    endif

    if index(checks, 'indent') > -1
      let mixed = CheckMixedIndent()
    endif

    let b:whitespace_check = ''
    if trailing != 0 || mixed != 0
      if trailing != 0
        let b:whitespace_check .=
            \' ' . printf(g:whitespace_trailing_format, trailing)
      endif
      if mixed != 0
        let b:whitespace_check .=
            \' ' . printf(g:whitespace_mixed_indent_format, mixed)
      endif
      let b:whitespace_check .= g:whitespace_symbol
    endif
  endif
  return b:whitespace_check
endfunction

function! WhitespaceReset()
  let b:whitespace_check = ''
  unlet b:whitespace_check
endfunction


function! ShortStatus()
  setlocal statusline=
  setlocal statusline+=%t
  setlocal statusline+=%4*%{Modified()}%*
endfunction

function! Status()
  if g:status_type == 'normal'
    setlocal statusline=
    setlocal statusline+=%2*%t%*
    setlocal statusline+=%1*%{Modified()}%*
    setlocal statusline+=%#warningmsg#
    setlocal statusline+=%{Syntastic()}
    setlocal statusline+=%{Whitespace()}
    setlocal statusline+=%*
    setlocal statusline+=%{Paste()}
    setlocal statusline+=%{RO()}
    setlocal statusline+=%=
    setlocal statusline+=\ %h%w
    setlocal statusline+=%y\ 
    setlocal statusline+=⭡\ %l,%v\ %P
  else
    setlocal statusline=
    setlocal statusline+=%3*%{VCSBranch()}%*
    setlocal statusline+=%2*%f%*
    setlocal statusline+=%1*%{Modified()}%*
    setlocal statusline+=%#warningmsg#
    setlocal statusline+=%{Syntastic()}
    setlocal statusline+=%{Whitespace()}
    setlocal statusline+=%*
    setlocal statusline+=%{Paste()}
    setlocal statusline+=%{RO()}
    setlocal statusline+=%=
    setlocal statusline+=\ %h%w
    setlocal statusline+=%y
    setlocal statusline+=[%{strlen(&fenc)?&fenc:'none'},%{&ff}]
    setlocal statusline+=\ 
    setlocal statusline+=⭡\ %l,%v\ %P
  end
endfunction

function! SwitchStatus()
  if g:status_type == 'normal'
    let g:status_type = 'full'
  else
    let g:status_type = 'normal'
  end
  call Status()
endfunction

let g:status_type = 'normal'

call NoHighlight()
call Status()

augroup StatusLine
  autocmd!

  autocmd InsertEnter * call Highlight()
  autocmd InsertLeave * call NoHighlight()

  autocmd BufEnter * call Status()
  autocmd WinEnter * call Status()
  autocmd WinLeave * call ShortStatus()

  autocmd BufWritePost * call WhitespaceReset()
augroup END

nmap <silent> <leader>h :call SwitchStatus()<cr>
" }}}
" {{{ ==| Plugins |=============================================================
" {{{ --| Surround |----------------------------------------
let g:surround_no_insert_mappings = 1
let g:surround_35 = "<%# \r %>"
let g:surround_37 = "<% \r %>"
let g:surround_61 = "<%= \r %>"
" }}}
" {{{ --| Tabular |-----------------------------------------
vmap <leader>t :Tabular /
" }}}
" {{{ --| Thesaurus |---------------------------------------
nnoremap gh :OnlineThesaurusCurrentWord<CR>
nnoremap gH :Thesaurus<space>
" }}}
" {{{ --| Emmet |-------------------------------------------
let g:user_emmet_leader_key=','
let g:use_emmet_complete_tag = 1
let g:user_emmet_settings = {
  \   'indentation' : '  '
  \ }
" }}}
" {{{ --| SimpleDB |----------------------------------------
let g:sql_type_default = 'mysql'
let g:omni_sql_no_default_maps = 1
augroup SQL
  autocmd!
  " For syntax coloring purposes
  autocmd BufEnter vim-simpledb-result.txt setf postgresql
  " Disable a bunch of visual feedback as this is generated content anyway
  autocmd BufReadPost vim-simpledb-result.txt highlight! link OverLength NULL
  autocmd BufReadPost vim-simpledb-result.txt setlocal nolist
augroup end
" }}}
" {{{ --| Signature |---------------------------------------
let g:SignatureMap = {
  \ 'Leader'             :  "m",
  \ 'PlaceNextMark'      :  "m,",
  \ 'ToggleMarkAtLine'   :  "m.",
  \ 'PurgeMarksAtLine'   :  "m-",
  \ 'PurgeMarks'         :  "m<Space>",
  \ 'PurgeMarkers'       :  "m<BS>",
  \ 'GotoNextLineAlpha'  :  "",
  \ 'GotoPrevLineAlpha'  :  "",
  \ 'GotoNextSpotAlpha'  :  "",
  \ 'GotoPrevSpotAlpha'  :  "",
  \ 'GotoNextLineByPos'  :  "",
  \ 'GotoPrevLineByPos'  :  "",
  \ 'GotoNextSpotByPos'  :  "",
  \ 'GotoPrevSpotByPos'  :  "",
  \ 'GotoNextMarker'     :  "",
  \ 'GotoPrevMarker'     :  "",
  \ 'GotoNextMarkerAny'  :  "",
  \ 'GotoPrevMarkerAny'  :  "",
  \ 'ListLocalMarks'     :  ""
  \ }
" }}}
" {{{ --| vCoolor |-----------------------------------------
nmap <leader>C :<c-u>VCoolor<cr>
nmap <leader>c :ColorToggle<cr>
" }}}
" {{{ --| Disptach |----------------------------------------
nmap <leader>f :Dispatch<cr>
nmap <leader>F :<c-u>Focus  %<left><left>
" }}}
" {{{ --| vim-test |----------------------------------------
let g:test#strategy = 'dispatch'
" }}}
" {{{ --| Targets |-----------------------------------------
let g:targets_pairs = '()b {}é []d <>É'
let g:targets_argTrigger = 'c'
" By default, we want to delete only the ACTUAL parameter
" Not the whitespaces around it
omap ic Ic
let g:targets_argOpening = '[({[]'
let g:targets_argClosing = '[]})]'
" }}}
" {{{ --| Syntastic |---------------------------------------
let g:syntastic_javascript_checkers = ['jsl']
let g:syntastic_ruby_checkers = ['mri']
let g:syntastic_javascript_ruboconf_conf = "~/.rubocop.yml"
let g:syntastic_ruby_rubocop_args = '-D'
let g:syntastic_haskell_checkers = ['hdevtools', 'hlint']
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_stl_format = '[%E{Err: %fe #%e}%B{, }%W{Warn: %fw #%w}]'
" }}}
" {{{ --| Greplace |----------------------------------------
set grepprg=ag\ --line-numbers\ --noheading
nmap <leader>A :Gqfopen<cr><c-w>T
nmap <leader>R :Greplace<cr>
" }}}
" {{{ --| Ag |----------------------------------------------
let g:ag_apply_qmappings = 0
let g:ag_apply_lmappings = 0
let g:ag_prg = "ag --column --line-numbers --noheading --smart-case"

nmap <leader>a :Ag! ""<left>
nmap <silent> <leader>é :set operatorfunc=UsageOperator<cr>g@iw
vmap <silent> <leader>é :<c-u>call UsageOperator(visualmode())<cr>
nmap <silent> <leader>É :set operatorfunc=DefinitionOperator<cr>g@iw
" }}}
" {{{ --| UltiSnips |---------------------------------------
let g:UltiSnipsRemoveSelectModeMappings = 1
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsJumpForwardTrigger="<c-t>"
let g:UltiSnipsJumpBackwardTrigger="<c-s>"
" }}}
" {{{ --| Taboo |-------------------------------------------
let g:taboo_tab_format =  " %N %f%m "
let g:taboo_renamed_tab_format =  " %N (%l)%m "
let g:taboo_modified_tab_flag = " ∙"
let g:taboo_unnamed_tab_label = "…"

nmap <leader>tl :TabooRename<space>
nmap <leader>tr :TabooReset<cr>
" }}}
" {{{ --| CtrlP |-------------------------------------------
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_switch_buffer = 'ET'
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:20,results:40'
let g:ctrlp_open_new_file = 't'
" Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
let g:ctrlp_map = '<c-t>'
map <c-s> :<c-u>CtrlPBufTag<cr>
map <leader><leader> :CtrlPTag<cr>
nmap <backspace> :<c-u>CtrlPClearCache<cr>
let g:ctrlp_prompt_mappings = {
  \   'PrtSelectMove("j")':   ['<c-t>', '<down>'],
  \   'PrtSelectMove("k")':   ['<c-s>', '<up>'],
  \   'AcceptSelection("h")': ['<c-x>'],
  \   'AcceptSelection("t")': ['<c-cr>', '<nl>', '<c-j>', ' '],
  \ }
highlight! CtrlPMatch ctermfg=5 guifg=#d33682
" }}}
" {{{ --| Signify |-----------------------------------------
let g:signify_vcs_list = [ 'hg', 'git' ]
let g:signify_update_on_focusgained = 1
" }}}
" {{{ --| Fugitive / Mercenary / Lawrencium |---------------
function! HgBranchStatus()
  silent tabnew /dev/null
  normal ggdG
  0read !hg status --rev "::. - ::default" -n
  silent :w
endfunction
command! HgBranchStatus call HgBranchStatus()

function! SwitchVCS()
  if g:next_vcs ==# 'mercurial'
    nmap <leader>S :Hgstatus<cr>
    nmap <leader>D :HGdiff ancestor(default,.)<cr>
    nmap <leader>b :HGblame<cr>
    nmap <leader>d :HGdiff<cr>
    nmap <leader>r :Hgrevert!<cr>:e<cr>
    let g:next_vcs = 'git'
  else
    nmap <leader>b :Gblame<cr>
    nmap <leader>d :Gvdiff<cr>
    nmap <leader>r :Gread<cr>
    nmap <leader>S :Gstatus<cr>
    let g:next_vcs = 'mercurial'
  endif
endfunction

vmap <leader>d :Linediff<cr>

let g:next_vcs = 'mercurial'
call SwitchVCS()
nmap <leader><tab> :call SwitchVCS()<cr>
" }}}
" }}}
" {{{ ==| Various keyboard mapping |============================================
" {{{ --| Exercism.io |-------------------------------------
nmap <silent> <leader>xf :Dispatch exercism f<cr>
nmap <silent> <leader>xs :Dispatch exercism s %<cr>
" }}}
" {{{ --| Buffers |-----------------------------------------
set switchbuf=usetab
" Empty buffers
command! B bufdo bd
nmap <leader>. :call DeleteHiddenBuffers()<cr>
" }}}
" {{{ --| Splits / Tabs |-----------------------------------
nmap <leader>o :tabo<cr>
nmap <leader>O :tabo<cr><c-w>o
nmap <leader>, <c-w>w
nmap <leader>; <c-w>W
noremap <c-w><c-c> <c-w>H
noremap <c-w><c-t> <c-w>J
noremap <c-w><c-s> <c-w>K
noremap <c-w><c-r> <c-w>L
" Horizontal Split
nmap <leader>nn :new<cr>
nmap <leader>ne :new <c-r>=escape(expand("%:p:h"), ' ') . '/'<cr>
nmap <leader>N :new<space>
" Vertical split
nmap <leader>vv :vnew<cr>
nmap <leader>ve :vnew <c-r>=escape(expand("%:p:h"), ' ') . '/'<cr>
nmap <leader>V :vnew<space>
" Dimensions
nmap <leader>M <c-w>=
nmap <leader>m :res<cr>:vertical res<cr>$
" New tab
nmap <leader>tt :tabe<cr>
nmap <leader>te :tabe <c-r>=escape(expand("%:p:h"), ' ') . '/'<cr>
nmap <leader>T :tabe<space>
" Close current tab
nmap <leader>tc :tabclose<cr>
" Close all tabs but current
nmap <leader>to :tabo<cr>
" Move current tab
nmap <leader>tm :tabm<space>
" Direct tab access
nnoremap <leader>" 1gt
nnoremap <leader>« 2gt
nnoremap <leader>» 3gt
nnoremap <leader>( 4gt
nnoremap <leader>) 5gt
nnoremap <leader>@ 6gt
nnoremap <leader>+ 7gt
nnoremap <leader>- 8gt
nnoremap <leader>/ 9gt

nmap <leader>U <c-w>T
nmap <leader>u :call MergeTabs()<cr>
" }}}
" {{{ --| Movement |----------------------------------------
" Diffs
map ß [c
map þ ]c
nmap <up> [c
nmap <down> ]c
" Marks
noremap ' `
noremap ` '
" Command line / Search
cmap <c-t> <down>
cmap <c-s> <up>
" Beginning / end of the line
inoremap <c-a> <c-o>^
cnoremap <c-a> <home>
inoremap <c-e> <c-o>$
cnoremap <c-e> <end>
map ç ^
" Split lines
noremap <c-j> i<cr><esc>
" Don't make a # force column zero.
inoremap # X<bs>#
" Fuck you, help.
nnoremap <F1> <nop>
inoremap <F1> <nop>
" Clever paste from system buffer
nmap <leader>p m`:set paste<cr>o<c-r>+<esc>:set nopaste<cr>``
nmap <leader>P m`:set paste<cr>O<c-r>+<esc>:set nopaste<cr>``
noremap <leader>y "+y
nnoremap yf :<c-u>let @+ = expand("%")<cr>:echo 'File name yanked.'<cr>
" Give a more logical behavior to Y
nnoremap Y y$
" Command line
map è :
map È :!
" }}}
" {{{ --| Mode Switching |----------------------------------
" Normal mode
set noesckeys
cmap <esc> <c-c>
" Exit
nnoremap à :q<cr>
nnoremap À :qa<cr>
nnoremap ê :bd<cr>
" Save
nmap <leader>s :w<cr>
" Disable annoying mapping
map Q <nop>
" Reselected pasted lines
nnoremap gV `[v`]
" Command line
map è :
map È :!
" Select current line charwise
" nnoremap vv ^v$h
" }}}
" {{{ --| Togglers |----------------------------------------
" Rename file
command! RenameFile :call RenameFile()
command! RF :call RenameFile()
" Toggle highlight current word
nmap <leader>' :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
" Toggle line wrap
nmap <leader>w :set wrap!<cr>
" Uppercase current word
nmap <c-g> gUiw
imap <c-g> <esc>lgUiwea
" Clear trailing spaces (but not the escaped ones)
nmap <silent> <leader>k
      \ :let _s=@/<Bar>:%s/[^.\\]\zs\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
" Fix indent
nmap <silent> <leader>i m'gg=Gg`'
" Cursorline / Cursorcolumn
nmap <leader>g :set cuc! \| set cul!<cr>
" Quickfix / Location list
nmap <silent> <leader>q :call ToggleQuickfixList()<cr>
nmap <silent> <leader>l :call ToggleLocationList()<cr>
" }}}
" {{{ --| Swap number line |--------------------------------
" It is more convenient to access numbers directly when in normal mode
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
noremap 8 -
noremap / 9
noremap 9 /
noremap * 0
noremap 0 *
" }}}
" {{{ --| Search & Replace |--------------------------------
noremap é /
map <silent> É :nohlsearch<cr><c-l>

nmap s :%s/
nmap S :s/
vmap s <esc>:%s/\%V/g<left><left>

nmap <c-n> :cnext<cr>
nmap <c-p> :cprev<cr>

command! NONASCII /[^\x00-\x7F]
" }}}
" {{{ --| Quick Editing |-----------------------------------
function! OpenSchemaFile()
  if filereadable('db/structure.sql')
    tabe db/structure.sql
  else
    tabe db/schema.rb
  endif
endfunction

nmap <leader>es :call OpenSchemaFile()<cr>

nmap <leader>ee :tabe ~/email.md<cr>
nmap <leader>ef :tabe ~/.config/fish/config.fish<cr>
nmap <leader>eg :tabe ~/.gitconfig<cr>
nmap <leader>eh :tabe ~/.hgrc<cr>
nmap <leader>em :tabe ~/.tmux.conf<cr>
nmap <leader>eo :tabe ~/poi.md<cr>
nmap <leader>ep :tabe ~/postgres.sql<cr>
nmap <leader>eq :tabe ~/sqlite.sql<cr>
nmap <leader>er :tabe ~/release.tasks<cr>
nmap <leader>et :tabe ~/todo.tasks<cr>
nmap <leader>ev :tabe $MYVIMRC<cr>

nmap <leader>e. :tabe .<cr>

nmap <leader># :e #<cr>

nmap <leader>$ :so $MYVIMRC<cr>
" }}}
" {{{ --| Convenience Mapping |-----------------------------
vmap <leader>s :sort<cr>
cnoremap %% <c-r>=expand('%:p:h')<cr>
nnoremap dD "_dd
" }}}
" }}}
" {{{ ==| Abbreviations |=======================================================
" }}}
