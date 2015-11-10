" vim:fdm=marker
" ------------------------------------------------------------------------------
" tlarrieu's nvimrc
" Designed for dvorak-bépo keyboard
" ------------------------------------------------------------------------------
set shell=/bin/bash
let $PAGER=''
let g:ruby_path = system('rvm current')
" {{{ ==| vim-plug |============================================================

call plug#begin('~/.vim/plugged')

" {{{ --| File Manipulation |--------------
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
Plug 'rking/ag.vim'
Plug 'duggiefresh/vim-easydir'
" }}}
" {{{ --| Functionnalities |---------------
Plug 'AndrewRadev/linediff.vim'
Plug 'beloglazov/vim-online-thesaurus'
Plug 'kassio/neoterm'
Plug 'tpope/vim-vinegar'
Plug 'aquach/vim-http-client'
Plug 'qpkorr/vim-renamer'
Plug 'vim-scripts/table-mode'
Plug 'skwp/greplace.vim'
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
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'edsono/vim-matchit'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'godlygeek/tabular'
Plug 'FooSoft/vim-argwrap'
" }}}
" {{{ --| Text objects |-------------------
Plug 'kana/vim-textobj-function'
Plug 'kana/vim-textobj-user'
Plug 'michaeljsmith/vim-indent-object'
Plug 'nelstrom/vim-textobj-rubyblock',
  \ { 'for' : [ 'ruby', 'eruby', 'rspec', 'rake' ] }
Plug 'tommcdo/vim-exchange'
Plug 'wellle/targets.vim'
" {{{ --| VCS |----------------------------
Plug 'mhinz/vim-signify'
Plug 'phleet/vim-mercenary'
Plug 'tpope/vim-fugitive'
Plug 'zeekay/vim-lawrencium'
" }}}
" {{{ --| Syntax checking |----------------
Plug 'benekastah/neomake'
" }}}
" }}}
" {{{ --| Task manager |-------------------
Plug 'samsonw/vim-task', { 'for' : [ 'task', 'tasks' ] }
" }}}
" {{{ --| List toggler |-------------------
Plug 'milkypostman/vim-togglelist'
" }}}
" {{{ --| Ruby |---------------------------
Plug 'jbgutierrez/vim-partial'
Plug 'tpope/vim-rails'
Plug 'vim-ruby/vim-ruby', { 'for' : 'ruby' }
" }}}
" {{{ --| HTML |---------------------------
Plug 'mattn/emmet-vim', { 'for' : [ 'html', 'eruby', 'sass', 'css'] }
" }}}
" {{{ --| Haskell |------------------------
" Plug 'bitc/vim-hdevtools', { 'for' : 'haskell' }
" Plug 'twinside/vim-syntax-haskell-cabal', { 'for' : 'haskell' }
" }}}
" {{{ --| Go lang |------------------------
" Plug 'fatih/vim-go', { 'for' : 'go' }
" }}}
" {{{ --| SQL |----------------------------
Plug 'krisajenkins/vim-postgresql-syntax'
" }}}
" {{{ --| Markdown |-----------------------
Plug 'jtratner/vim-flavored-markdown'
" }}}
" {{{ --| Misc languages support |---------
Plug 'alfredodeza/jacinto.vim', { 'for' : 'json' }
Plug 'chrisbra/csv.vim', { 'for' : 'csv' }
Plug 'jelera/vim-javascript-syntax', { 'for' : 'javascript' }
Plug 'kchmck/vim-coffee-script', { 'for' : 'coffee' }
" Plug 'lambdatoast/elm.vim', { 'for' : 'elm' }
Plug 'leshill/vim-json', { 'for' : 'json' }
Plug 'lmeijvogel/vim-yaml-helper', { 'for' : 'yaml' }
Plug 'roalddevries/yaml.vim', { 'for' : 'yaml' }
Plug 'vim-scripts/fish-syntax', { 'for' : 'fish' }
" }}}
" {{{ --| Good looking |-------------------
Plug 'altercation/vim-colors-solarized'
Plug 'gcmt/taboo.vim'
Plug 'kshenoy/vim-signature'
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
  autocmd BufReadPost *.arb setfiletype ruby
  autocmd BufReadPost COMMIT_EDITMSG startinsert!
  autocmd FileType html,eruby setlocal foldlevel=10
  autocmd FileType html setlocal foldmethod=syntax
  autocmd FileType html setlocal foldminlines=1
  autocmd BufReadPost *.yml setfiletype yaml
  autocmd BufReadPost *.diag setfiletype seqdiag
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
set nottimeout
" History
set history=500
" Color / background theme
set background=light
colorscheme solarized

highlight! link SignColumn LineNr
highlight! link CursorLineNr Directory
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
" Blank character
set lcs=tab:\›\ ,trail:·,nbsp:¬,extends:»,precedes:«
" Display blank characters
set list
" Show incomplete key sequence in bottom corner
set showcmd
" Encoding and filetype
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
nnoremap <leader>Z zR
nnoremap zO zczO
" }}}
" {{{ ==| Searching |===========================================================
" case behavior regarding searching
set ignorecase
set smartcase
" some more search related stuff
set hlsearch  " highlight search
set incsearch " start search while typing
" }}}
" {{{ ==| Spellchecking |=======================================================
set spelllang=en,fr
" }}}
" {{{ ==| Plugins |=============================================================
" {{{ --| ArgWrap |-----------------------------------------
nnoremap <silent> <leader>; :ArgWrap<CR>
" }}}
" {{{ --| HttpClient |--------------------------------------
let g:http_client_bind_hotkey = 0
let g:http_client_result_vsplit = 0
augroup HTTPClient
  autocmd!
  autocmd BufReadPost httpclient map <buffer> <return> :HTTPClientDoRequest<cr>
augroup END
" }}}
" {{{ --| FZF |---------------------------------------------
" Standard mode (file list)
nmap <silent> <c-t> :<c-u>FZF -m -e<cr>

" Buffer list
function! s:buflist()
  redir => ls
  silent ls
  redir END
  return split(ls, '\n')
endfunction

function! s:bufopen(e)
  if len(a:e) < 2 | return | endif
  let key = a:e[0]
  let lines = a:e[1:]

  let cmd = get({
    \ 'ctrl-x': 'split|buffer',
    \ 'ctrl-v': 'vertical split|buffer',
    \ 'ctrl-t': 'tabnew|buffer',
    \ 'ctrl-d': 'bdelete!'
    \ }, key, 'buffer')

  for buf in map(lines, 'split(v:val, " ")[0]')
    execute cmd . ' ' . buf
  endfor
endfunction

nnoremap <silent> <c-b> :call fzf#run({
  \   'source':  reverse(<sid>buflist()),
  \   'sink*':    function('<sid>bufopen'),
  \   'options': '--expect=ctrl-t,ctrl-v,ctrl-x,ctrl-d --multi',
  \   'down':    len(<sid>buflist()) + 2
  \ })<cr>

" Ag results narrowing
function! s:agopen(lines)
  if len(a:lines) < 2 | return | endif

  let [key, line] = a:lines[0:1]
  let [file, line, col] = split(line, ':')[0:2]
  let cmd = get({
    \ 'ctrl-x': 'split',
    \ 'ctrl-v': 'vertical split',
    \ 'ctrl-t': 'tabe'
    \ }, key, 'e')
  execute cmd escape(file, ' %#\')
  execute line
  execute 'normal!' col.'|zz'
endfunction

command! -nargs=1 Fg call fzf#run({
  \ 'source': 'ag --nogroup --column --color "' . escape(<q-args>, '"\') . '"',
  \ 'sink*': function('<sid>agopen'),
  \ 'options': '--ansi --expect=ctrl-t,ctrl-v,ctrl-x --no-multi --color hl:68,hl+:110 -e',
  \ 'down': '50%'
  \ })
nnoremap <leader>a :<c-u>Fg<space>
" }}}
" {{{ --| Neomake |-----------------------------------------
augroup Neomake
  autocmd!
  autocmd BufWritePost * Neomake
augroup END
" }}}
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
  autocmd BufEnter vim-simpledb-result.txt setfiletype postgresql
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
" {{{ --| Targets |-----------------------------------------
let g:targets_pairs = '()b {}é []d <>É'
let g:targets_argTrigger = 'c'
" By default, we want to delete only the ACTUAL parameter
" Not the whitespaces around it
omap ic Ic
let g:targets_argOpening = '[({[]'
let g:targets_argClosing = '[]})]'
" }}}
" {{{ --| Ag |----------------------------------------------
let g:ag_apply_qmappings = 0
let g:ag_apply_lmappings = 0
let g:ag_prg = "ag --column --line-numbers --noheading --smart-case"

nmap <leader>A :Ag! ""<left>
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

function! HgHistory()
  let file = expand('%')
  execute 'Hg! history -p ' . file
  setfiletype diff
endfunction

function! SwitchVCS()
  if g:next_vcs ==# 'mercurial'
    nmap <leader>s :Hgstatus<cr>
    nmap <leader>D :HGdiff ancestor(default,.)<cr>
    nmap <leader>b :HGblame<cr>
    nmap <leader>d :HGdiff<cr>
    nmap <leader>r :Hgrevert!<cr>:e<cr>
    nmap <leader>H :call HgHistory()<cr>
    let g:next_vcs = 'git'
  else
    nmap <leader>b :Gblame<cr>
    nmap <leader>d :Gvdiff<cr>
    nmap <leader>r :Gread<cr>
    nmap <leader>s :Gstatus<cr>
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
" {{{ --| Buffers |-----------------------------------------
" Reuse previously opened tab / window when trying to open a buffer
set switchbuf=usetab
" Empty buffers
command! B bufdo bd
nmap <leader><leader> :call DeleteHiddenBuffers()<cr>
" }}}
" {{{ --| Splits / Tabs |-----------------------------------
nmap <leader>o :tabo<cr>
nmap <leader>O :tabo<cr><c-w>o
nmap <leader>, gt
nmap <leader>c gT
" Hack to make <c-w><c-c> mapping work
nmap <c-c> <nop>
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
" Moving around
nmap <up> <c-w><up>
nmap <down> <c-w><down>
nmap <left> <c-w><left>
nmap <right> <c-w><right>
nmap <tab> <c-w>w
nmap <s-tab> <c-w>W
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

" Move tabs
nnoremap <leader>t* :tabmove 0<cr>
nnoremap <leader>t" :tabmove 1<cr>
nnoremap <leader>t« :tabmove 2<cr>
nnoremap <leader>t» :tabmove 3<cr>
nnoremap <leader>t( :tabmove 4<cr>
nnoremap <leader>t) :tabmove 5<cr>
nnoremap <leader>t@ :tabmove 6<cr>
nnoremap <leader>t+ :tabmove 7<cr>
nnoremap <leader>t- :tabmove 8<cr>
nnoremap <leader>t/ :tabmove 9<cr>

nmap <leader>U <c-w>T
nmap <leader>u :call MergeTabs()<cr>
" }}}
" {{{ --| Terminal |----------------------------------------
tnoremap <c-s> <c-\><c-n>

map <silent> <leader>ti :terminal<cr>
map <silent> <leader>vi :vertical new<bar>terminal<cr>
map <leader>tu :terminal<space>
map <leader>vu :vsplit<bar>terminal<space>
" }}}
" {{{ --| Movement |----------------------------------------
" Diffs
map ß [c
map þ ]c
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
" Close current buffer
map Q :bd!<cr>
" Normal mode
set noesckeys
cmap <esc> <c-c>
" Exit
nnoremap à :q<cr>
nnoremap À :qa<cr>
nnoremap ê :bd<cr>
" Save
nmap <c-s> :update<cr>
imap <c-s> <esc>:update<cr>
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
function! ClearTrailingSpaces()
  let _s=@/
  %s/\v(^\s+$|[\\]\s\zs\s+$|[^\\]\zs\s+$)//e
  let @/=_s
  nohl
endfunction
nmap <silent> <leader>k m`:call ClearTrailingSpaces()<cr>g``
" Fix indent
nmap <silent> <leader>i m`gg=Gg``:call ClearTrailingSpaces()<cr>
" Cursorline / Cursorcolumn
let g:virtualedit=''
function! AlignMode()
  if g:virtualedit
    let g:virtualedit=0
    set virtualedit=""
  else
    let g:virtualedit=1
    set virtualedit=all
  endif
  set cursorcolumn!
  set cursorline!
endfunction
nmap <leader>g :call AlignMode()<cr>
" Quickfix / Location list
nmap <silent> <leader>q :call ToggleQuickfixList()<cr>
nmap <silent> <leader>l :call ToggleLocationList()<cr>
" Statusline
nmap <silent> <leader>h :call SwitchStatus()<cr>
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
noremap <silent> É :nohlsearch<cr><c-l>

nmap s :s/
nmap S :%s/
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

nmap <leader>ea :tabe ~/httpclient<cr>
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
nmap <leader>ev :tabe ~/.nvimrc<cr>

nmap <leader>. :e .<cr>

nmap <leader># :e #<cr>

nmap <silent> <leader>$ :so ~/.nvimrc<cr>:so ~/.vim/plugin/statusline.vim<cr>
" }}}
" {{{ --| Convenience Mapping |-----------------------------
vmap <leader>s :sort<cr>
cnoremap %% <c-r>=expand('%:p:h')<cr>
nnoremap dD "_dd
cmap w!! w !sudo tee % >/dev/null
" }}}
" }}}
