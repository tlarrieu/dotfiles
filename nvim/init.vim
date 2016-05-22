" vim:fdm=marker
" ------------------------------------------------------------------------------
" tlarrieu's nvimrc
" Designed for dvorak-bépo keyboard
" ------------------------------------------------------------------------------
set shell=/bin/bash
let $PAGER=''
let g:ruby_path = system('rvm current')
" {{{ ==| vim-plug |============================================================

call plug#begin()

" {{{ --| File Manipulation |--------------
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
Plug 'rking/ag.vim'
Plug 'duggiefresh/vim-easydir'
Plug 'tlarrieu/vim-sniper'
" }}}
" {{{ --| Functionnalities |---------------
Plug 'AndrewRadev/linediff.vim'
Plug 'beloglazov/vim-online-thesaurus'
Plug 'kassio/neoterm'
Plug 'tpope/vim-vinegar'
Plug 'diepm/vim-rest-console'
Plug 'vim-scripts/AnsiEsc.vim'
Plug 'shougo/deoplete.nvim'
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
Plug 'edsono/vim-matchit'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'godlygeek/tabular', { 'on' : 'Tabular' }
Plug 'FooSoft/vim-argwrap'
" }}}
" {{{ --| Text objects |-------------------
Plug 'kana/vim-textobj-function'
Plug 'kana/vim-textobj-user'
Plug 'michaeljsmith/vim-indent-object'
Plug 'nelstrom/vim-textobj-rubyblock',
  \ { 'for' : [ 'ruby', 'eruby', 'rspec', 'rake', 'crystal' ] }
Plug 'tommcdo/vim-exchange'
Plug 'wellle/targets.vim'
" {{{ --| Git |----------------------------
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
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
Plug 'mattn/emmet-vim'
" }}}
" {{{ --| SQL |----------------------------
Plug 'krisajenkins/vim-postgresql-syntax'
" }}}
" {{{ --| Markdown |-----------------------
Plug 'tpope/vim-markdown'
" }}}
" {{{ --| Misc languages support |---------
Plug 'alfredodeza/jacinto.vim', { 'for' : 'json' }
Plug 'chrisbra/csv.vim', { 'for' : 'csv' }
Plug 'jelera/vim-javascript-syntax', { 'for' : 'javascript' }
Plug 'kchmck/vim-coffee-script', { 'for' : 'coffee' }
Plug 'leshill/vim-json', { 'for' : 'json' }
Plug 'lmeijvogel/vim-yaml-helper', { 'for' : 'yaml' }
Plug 'roalddevries/yaml.vim', { 'for' : 'yaml' }
Plug 'vim-scripts/fish-syntax', { 'for' : 'fish' }
Plug 'mustache/vim-mustache-handlebars'
Plug 'rhysd/vim-crystal'
" }}}
" {{{ --| Good looking |-------------------
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'blueyed/vim-diminactive'
Plug 'altercation/vim-colors-solarized'
Plug 'gcmt/taboo.vim'
Plug 'kshenoy/vim-signature'
" }}}

call plug#end()

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
" Pipe shaped cursor in insert mode
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
let mapleader="\<space>"
" Avoiding moving cursor when hitting <space> followed by nothing
map <space> <nop>
" Timeout
set nottimeout
" Color / background theme
set background=light
colorscheme solarized
highlight! link SignColumn LineNr
highlight! link CursorLineNr Directory
" Deactivate parenthesis matching
let loaded_matchparen = 1
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
set listchars=tab:\›\ ,trail:·,nbsp:¬,extends:»,precedes:«
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
set mouse=
" Command completion style
set wildmode=list:full,full
set complete=.,w,b,u,t,i
" Bells
set novisualbell
set noerrorbells
" Allow a modified buffer to be sent to background without saving it
set hidden
" Set title when in console
set title
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
" Update time
set updatetime=250
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
" }}}
" {{{ ==| Spellchecking |=======================================================
set spelllang=en,fr
" }}}
" {{{ ==| Plugins |=============================================================
" {{{ --| Crystal |-----------------------------------------
let g:crystal_auto_format = 1
" }}}
" {{{ --| VimRestClient |-----------------------------------
let g:vrc_max_time = 5
let g:vrc_set_default_mapping = 0
augroup VimRestClient
  autocmd!
  autocmd FileType rest nmap <buffer> <return> :call VrcQuery()<cr>
augroup END
" }}}
" {{{ --| Diminactive |-------------------------------------
let g:diminactive_buftype_blacklist = []
let g:diminactive_use_colorcolumn = 1
let g:diminactive_use_syntax = 0
let g:airline#extensions#hunks#enabled = 0
" }}}
" {{{ --| Airline |-----------------------------------------
let g:airline_powerline_fonts = 1
let g:airline#extensions#whitespace#trailing_format = 'tr [%s]'
let g:airline#extensions#whitespace#mixed_indent_format = 'mi [%s]'
" }}}
" {{{ --| Deoplete |----------------------------------------
let g:deoplete#enable_at_startup = 1
let g:deoplete#disable_auto_complete = 0
let g:deoplete#auto_complete_start_length = 6
inoremap <silent><expr> <c-n>
\ pumvisible() ? "\<C-n>" :
\ deoplete#mappings#manual_complete()
" }}}
" {{{ --| Sniper |------------------------------------------
vmap <cr> :<c-u>call Snipe('vnew')<cr>
" }}}
" {{{ --| ArgWrap |-----------------------------------------
nnoremap <silent> <leader>; :ArgWrap<CR>
" }}}
" {{{ --| FZF |---------------------------------------------
" Standard mode (file list)
nmap <silent> <c-t> :FZF -m -e<cr>

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
function! s:agopen(e)
  if len(a:) < 2 | return | endif

  let key = a:e[0]
  let cmd = get({
    \ 'ctrl-x': 'split',
    \ 'ctrl-v': 'vertical split',
    \ 'ctrl-t': 'tabe'
    \ }, key, 'e')

  let lines = a:e[1:]
  for line in map(lines, 'split(v:val, " ")[0]')
    let [file, line, col] = split(line, ':')[0:2]
    execute cmd escape(file, ' %#\')
    execute line
    execute 'normal!' col.'|zz'
  endfor
endfunction

command! -nargs=1 Fgnc call fzf#run({
  \ 'source': 'ag -i --nogroup --column "' . escape(<q-args>, '"\') . '"',
  \ 'sink*': function('<sid>agopen'),
  \ 'options': '--ansi --expect=ctrl-t,ctrl-v,ctrl-x --no-multi --color hl:68,hl+:110 -e --multi',
  \ 'down': '50%'
  \ })
command! -nargs=1 Fg call fzf#run({
  \ 'source': 'ag -i --nogroup --column --color "' . escape(<q-args>, '"\') . '"',
  \ 'sink*': function('<sid>agopen'),
  \ 'options': '--ansi --expect=ctrl-t,ctrl-v,ctrl-x --no-multi --color hl:68,hl+:110 -e --multi',
  \ 'down': '50%'
  \ })
nnoremap <c-e> :<c-u>Fg<space>
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
let g:user_emmet_leader_key='<c-y>'
let g:use_emmet_complete_tag = 1
let g:user_emmet_mode = 'i'
let g:user_emmet_install_global = 1
let g:user_emmet_settings = {
  \   'indentation' : '  '
  \ }
let g:user_emmet_expandabbr_key = '<c-l>'
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
let g:ag_prg = "ag --vimgrep"
set grepformat=%f:%l:%c:%m

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
" {{{ --| Fugitive |----------------------------------------
nmap <leader>b :Gblame<cr>
nmap <leader>d :Gvdiff<cr>
nmap <leader>D :Gvdiff develop<cr>
nmap <leader>r :Gread<cr>
nmap <leader>s :Gstatus<cr>
nmap <leader>S :GV<cr>
nmap <leader>f :Gfetch<space>
nmap <leader>w :Gwrite<cr>

vmap <leader>d :Linediff<cr>
" }}}
" }}}
" {{{ ==| Various keyboard mapping |============================================
" {{{ --| Buffers |-----------------------------------------
" Reuse previously opened tab / window when trying to open a buffer
set switchbuf=usetab
" Empty buffers
function! ClearBuffers()
  silent! bufdo bdelete
  silent! tabdo tabclose
  edit .
endfunction
command! B :call ClearBuffers()
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
" Vertical split
nmap <leader>vv :vnew<cr>
nmap <leader>ve :vnew <c-r>=escape(expand("%:p:h"), ' ') . '/'<cr>
" Dimensions
nmap <leader>= <c-w>=
nmap <leader>% :res<cr>:vertical res<cr>
" Moving around
nmap <tab> <c-w>w
nmap <s-tab> <c-w>W
" New tab
nmap <leader>tt :tabe<cr>
nmap <leader>te :tabe <c-r>=escape(expand("%:p:h"), ' ') . '/'<cr>
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
" {{{ --| Terminal |----------------------------------------
tnoremap <c-s> <c-\><c-n>

nmap <silent> <leader>ti :terminal<cr>
nmap <silent> <leader>vi :vertical new<bar>terminal<cr>
nmap <silent> <leader>vr :vertical new<bar>terminal rails c<cr>
nmap <silent> <leader>ni :new<bar>terminal<cr>
nmap <silent> <leader>nr :new<bar>terminal rails c<cr>
nmap <leader>tu :terminal<space>
nmap <leader>vu :vsplit<bar>terminal<space>
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
" Visual yank
vnoremap y ygv<esc>
vnoremap Y Ygv<esc>
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
" nmap <silent> <leader>h :call SwitchStatus()<cr>
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
noremap 7 :GitGutterStageHunk<cr>
noremap - 8
noremap 8 :GitGutterRevertHunk<cr>
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

nmap <leader>ea :tabe ~/httpclient.rest<cr>
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
nmap <leader>ev :tabe ~/.config/nvim/init.vim<cr>

nmap <leader>. :Lexplore .<cr>

nmap <leader># :e #<cr>

nmap <silent> <leader>$ :so ~/.config/nvim/init.vim<cr>:so ~/.config/nvim/plugin/statusline.vim<cr>
" }}}
" {{{ --| Convenience Mapping |-----------------------------
vmap <leader>s :sort<cr>

nnoremap <silent> K :new<bar>terminal dasht <c-r><c-w><cr>
" }}}
" }}}
