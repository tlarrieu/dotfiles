" vim:fdm=marker
" ------------------------------------------------------------------------------
" tlarrieu's nvimrc
" Designed for dvorak-bépo keyboard
" ------------------------------------------------------------------------------
set shell=/bin/sh
" {{{ ==| vim-plug |============================================================
call plug#begin()
" {{{ --| File Manipulation |--------------
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
Plug 'mileszs/ack.vim'
Plug 'duggiefresh/vim-easydir'
" }}}
" {{{ --| Project manipulation |-----------
Plug 'tpope/vim-projectionist'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
" }}}
" {{{ --| Functionnalities |---------------
Plug 'AndrewRadev/linediff.vim', { 'on': 'Linediff' }
Plug 'beloglazov/vim-online-thesaurus'
Plug 'kassio/neoterm'
Plug 'tpope/vim-vinegar'
Plug 'diepm/vim-rest-console'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'thinca/vim-qfreplace', { 'on': 'Qfreplace' }
Plug 'janko-m/vim-test'
Plug 'tlarrieu/vim-sniper'
Plug 'neomake/neomake'
Plug 'sbdchd/neoformat'
Plug 'milkypostman/vim-togglelist'
Plug 'vimwiki/vimwiki'
" }}}
" {{{ --| Snippets |-----------------------
Plug 'SirVer/ultisnips'
Plug 'mattn/emmet-vim'
" }}}
" {{{ --| Text manipulation |--------------
Plug 'AndrewRadev/switch.vim'
Plug 'vim-scripts/matchit.zip'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'godlygeek/tabular', { 'on' : 'Tabular' }
Plug 'FooSoft/vim-argwrap'
Plug 'dkarter/bullets.vim'
" }}}
" {{{ --| Text objects |-------------------
Plug 'kana/vim-textobj-function'
Plug 'kana/vim-textobj-user'
Plug 'austintaylor/vim-indentobject'
Plug 'nelstrom/vim-textobj-rubyblock',
  \ { 'for' : ['ruby', 'eruby', 'rspec', 'rake', 'elixir'] }
Plug 'tommcdo/vim-exchange'
Plug 'b4winckler/vim-angry'
Plug 'machakann/vim-highlightedyank'
" }}}
" {{{ --| Languages suport |---------------
Plug 'tpope/vim-rails'
Plug 'neovimhaskell/haskell-vim'
Plug 'vifm/vifm.vim'
Plug 'dag/vim-fish'
Plug 'vim-scripts/gnuplot-syntax-highlighting'
Plug 'othree/html5.vim'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'LaTeX-Box-Team/LaTeX-Box'
Plug 'wgwoods/vim-systemd-syntax'
Plug 'lmeijvogel/vim-yaml-helper'
Plug 'krisajenkins/vim-postgresql-syntax'
Plug 'tbastos/vim-lua'
Plug 'elixir-editors/vim-elixir'
Plug 'slashmili/alchemist.vim', { 'for': 'elixir' }
Plug 'elmcast/elm-vim', { 'for': 'elm' }
Plug 'qbit/taskwarrior-vim'
Plug 'bhurlow/vim-parinfer', { 'for': ['lisp', 'clojure', 'racket'] }
" }}}
" {{{ --| Good looking |-------------------
Plug 'altercation/vim-colors-solarized'
Plug 'gcmt/taboo.vim'
Plug 'kshenoy/vim-signature'
" }}}
" {{{ --| Other |--------------------------
Plug 'vim-scripts/AnsiEsc.vim', { 'on': 'AnsiEsc' }
Plug 'ap/vim-css-color'
" }}}
call plug#end()
" }}}
" {{{ ==| File Related |========================================================
augroup vimrc_autocmd
  autocmd!
  autocmd FileType html,eruby setlocal foldlevel=10
  autocmd FileType html setlocal foldmethod=syntax
  autocmd FileType html setlocal foldminlines=1
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
  autocmd Bufenter * let w:last_fdm=&foldmethod
  autocmd InsertEnter * let w:last_fdm=&foldmethod | setlocal foldmethod=manual
  autocmd InsertLeave * let &l:foldmethod=w:last_fdm
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
function! Autosize()
  let l:tabnr = tabpagenr()
  tabdo normal! =
  exec "normal! " . l:tabnr . "gt"
endfunction
augroup dimensions
  autocmd!
  " autoreflow splits upon changing nvim size (most often happens when tiling
  " windows)
  autocmd VimResized * call Autosize()
augroup END
" Leader
let g:mapleader="\<space>"
" Avoiding moving cursor when hitting <space> followed by nothing
map <space> <nop>
" Project specific settings
set exrc
set secure
" Always display tabline
set showtabline=1
" Do not display mode
set noshowmode
" Line numbering (relative and current)
set relativenumber
set number
" textwidth
set textwidth=80
" Blank character
set listchars=tab:\›\ ,trail:·,nbsp:¬,extends:»,precedes:«
" Display blank characters
set list
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
" Change netrw list style
let g:netrw_liststyle=3
" inccommand
set inccommand=nosplit
set signcolumn=yes
" }}}
" {{{ ==| Splits |==============================================================
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
" {{{ ==| Statusline |==========================================================
set statusline=
set statusline+=%*
set statusline+=%f\                             " path
set statusline+=%(\%{statusline#Readonly()}\ %)
set statusline+=%(%{statusline#Modified()}\ %)
set statusline+=%(%{statusline#Paste()}\ %)
set statusline+=%*%=\ %*                        " align right
set statusline+=%#warningmsg#
set statusline+=%(%{statusline#Whitespace()}\ %)
set statusline+=%*
set statusline+=%(%y\ %)                        " file type
set statusline+=(%l,%c)\                        " line and column
set statusline+=%P\                             " percentage of file
set statusline+=%*
" }}}
" {{{ ==| Plugins |=============================================================
" {{{ --| vimwiki |-----------------------------------------
let g:vimwiki_global_vars = {}
let g:vimwiki_hl_headers = 0
let g:vimwiki_key_mappings = { 'all_maps': 0, }

let g:vimwiki_list = [{
  \ 'path': '~/.vimwiki/home',
  \ 'syntax': 'markdown',
  \ 'ext': '.md'
  \ },
  \ {
  \ 'path': '~/.vimwiki/work',
  \ 'syntax': 'markdown',
  \ 'ext': '.md',
  \ 'nested_syntaxes': { 'sql': 'sql' }
  \ }]
" }}}
" {{{ --| Bullets |-----------------------------------------
let g:bullets_set_mappings = 0
" }}}
" {{{ --| Emmet |-------------------------------------------
let g:user_emmet_install_global = 0
let g:user_emmet_leader_key = '<c-b>'
let g:user_emmet_mode = 'iv'
let g:user_emmet_settings = { 'javascript.jsx': { 'extends': 'jsx' } }
augroup Emmet
  autocmd FileType html,css,javascript,jsx,eelixir EmmetInstall
augroup END
" }}}
" {{{ --| vim-test |----------------------------------------
let g:test#strategy = 'neoterm'
" }}}
" {{{ --| VimRenamer |--------------------------------------
augroup VimRenamer
  autocmd!
  autocmd BufFilePost VimRenamer nmap <buffer> <c-s> :Ren<cr>
augroup END
" }}}
" {{{ --| HighlightedYank |---------------------------------
let g:highlightedyank_highlight_duration = 180
" }}}
" {{{ --| Neoterm |-----------------------------------------
let g:neoterm_default_mod = 'botright'
let g:neoterm_autoscroll = 1
let g:neoterm_size = 12
let g:neoterm_automap_keys = '<leader>vttttt'
nmap <silent> <leader><tab> :Ttoggle<cr>
" }}}
" {{{ --| Deoplete |----------------------------------------
let g:deoplete#enable_at_startup = 1
call deoplete#custom#option({
  \   'smart_case': v:true,
  \   'min_pattern_length': 3
  \ })
let g:deoplete#tag#cache_limit_size = 600000
call deoplete#custom#source('_', 'matchers', ['matcher_fuzzy'])
" }}}
" {{{ --| Rails |-------------------------------------------
vmap <leader>x :Rextract<space>
" }}}
" {{{ --| GitGutter |---------------------------------------
let g:gitgutter_map_keys = 0
nmap <expr> ß &diff ? '[c' : '<Plug>(GitGutterPrevHunk)'
nmap <expr> þ &diff ? ']c' : '<Plug>(GitGutterNextHunk)'
" }}}
" {{{ --| VimRestConsole |----------------------------------
let g:vrc_set_default_mapping = 0
let g:vrc_split_request_body = 1
let g:vrc_curl_opts = { '-L': '', '-i': '', '-s' : '' }
augroup VimRestConsole
  autocmd!
  autocmd FileType rest nmap <buffer> <return> :call VrcQuery()<cr>
augroup END
" }}}
" {{{ --| ArgWrap |-----------------------------------------
nnoremap <silent> <leader>, :ArgWrap<CR>
" }}}
" {{{ --| FZF |---------------------------------------------
" Standard mode (file list)
nmap <silent> <c-t> :FZF -m -e<cr>
" Custom modes (home made funcctions)
nnoremap <silent> <c-b> :FZFbuf<cr>
nnoremap <c-e> :FZFsearch<space>
nnoremap <silent> <c-c> :FZFtags tag<cr>
nnoremap <silent> <c-l> :FZFtags tag<cr>
nnoremap <silent> <c-y> :FZFGitFiles<cr>
let g:fzf_colors = {
  \   'fg':      ['fg', 'Normal'],
  \   'bg':      ['bg', 'Normal'],
  \   'hl':      ['fg', 'Comment'],
  \   'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \   'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \   'hl+':     ['fg', 'Statement'],
  \   'info':    ['fg', 'PreProc'],
  \   'prompt':  ['fg', 'Conditional'],
  \   'pointer': ['fg', 'Exception'],
  \   'marker':  ['fg', 'Keyword'],
  \   'spinner': ['fg', 'Label'],
  \   'header':  ['fg', 'Comment']
  \ }
" }}}
" {{{ --| Neomake |-----------------------------------------
call neomake#configure#automake('w')

let g:neomake_vint_maker = {
  \ 'exe': 'vint',
  \ 'args': ['%:p'],
  \ }

let g:neomake_error_sign = {
  \ 'text': '',
  \ 'texthl': 'ErrorMsg'
  \ }
let g:neomake_warning_sign = {
  \ 'text': '',
  \ 'texthl': 'WarningMsg',
  \ }
let g:neomake_message_sign = {
  \ 'text': '',
  \ 'texthl': 'NeomakeMessageSign',
  \ }
let g:neomake_info_sign = {
  \ 'text': '',
  \ 'texthl': 'NeomakeInfoSign'
  \ }
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
" {{{ --| Signature |---------------------------------------
let g:SignatureMap = {
  \ 'Leader'            : 'm',
  \ 'PlaceNextMark'     : '',
  \ 'ToggleMarkAtLine'  : '',
  \ 'PurgeMarksAtLine'  : '',
  \ 'PurgeMarks'        : '',
  \ 'PurgeMarkers'      : '',
  \ 'GotoNextLineAlpha' : '',
  \ 'GotoPrevLineAlpha' : '',
  \ 'GotoNextSpotAlpha' : '',
  \ 'GotoPrevSpotAlpha' : '',
  \ 'GotoNextLineByPos' : '',
  \ 'GotoPrevLineByPos' : '',
  \ 'GotoNextSpotByPos' : '',
  \ 'GotoPrevSpotByPos' : '',
  \ 'GotoNextMarker'    : '',
  \ 'GotoPrevMarker'    : '',
  \ 'GotoNextMarkerAny' : '',
  \ 'GotoPrevMarkerAny' : '',
  \ 'ListLocalMarks'    : ''
  \ }
" }}}
" {{{ --| Angry |-------------------------------------------
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
" {{{ --| Ack |---------------------------------------------
let g:ack_apply_qmappings = 0
let g:ack_apply_lmappings = 0
let g:ackprg = 'ag --vimgrep'
set grepformat=%f:%l:%c:%m
" }}}
" {{{ --| UltiSnips |---------------------------------------
let g:UltiSnipsRemoveSelectModeMappings = 1
let g:UltiSnipsEditSplit='vertical'
let g:UltiSnipsJumpForwardTrigger='<tab>'
let g:UltiSnipsJumpBackwardTrigger='<s-tab>'
let g:UltiSnipsSnippetsDir='~/.config/nvim/UltiSnips'
" }}}
" {{{ --| Taboo |-------------------------------------------
let g:taboo_tab_format = ' %N %f%m '
let g:taboo_renamed_tab_format = ' %N (%l)%m '
let g:taboo_modified_tab_flag = ' ∙'
let g:taboo_unnamed_tab_label = '…'
nmap <leader>tl :TabooRename<space>
nmap <leader>tr :TabooReset<cr>
" }}}
" {{{ --| Fugitive |----------------------------------------
nmap <leader>a :Gcommit --quiet --amend --no-edit<cr>
nmap <leader>A :Gcommit --quiet --amend<cr>
nmap <leader>b :Gblame<cr>
nmap <leader>c :Gcommit --quiet<cr>
nmap <leader>d :Gvdiff<cr>
nmap <leader>D :Gvdiff master<cr>
nmap <leader>ed :tab Git diff --staged<cr>
nmap <leader>r :Gread<cr>
nmap <leader>R :Git reset %<cr>
nmap <leader>s :Gstatus<cr>
nmap <leader>S :GV<cr>
vmap <leader>S :'<,'>GV<cr>
nmap <leader>w :Gwrite<cr>
" }}}
" {{{ --| Linediff |----------------------------------------
vmap <leader>d :Linediff<cr>
" }}}
" }}}
" {{{ ==| Various keyboard mapping |============================================
" {{{ --| Splits / Tabs |-----------------------------------
nnoremap co :tabo<cr><c-w>o
nnoremap <leader>o <c-w>o
" Hack to make <c-w><c-c> mapping work
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
nnoremap <c-right> <c-w>>
nnoremap <c-left> <c-w><
nnoremap <c-up> <c-w>-
nnoremap <c-down> <c-w>+
" Moving around
nmap <tab> <c-w>w
nmap <s-tab> <c-w>W
nmap <c-n> gt
nmap <c-p> gT
" New tab
nmap <leader>tt :tabe<cr>
nmap <leader>te :tabe <c-r>=escape(expand("%:p:h"), ' ') . '/'<cr>
" Move current tab
nmap <leader>tm :tabm<space>
" Tab merge and “unmerge”
nmap <leader>U <c-w>T
nmap <leader>u :call MergeTabs()<cr>
" }}}
" {{{ --| Terminal |----------------------------------------
tnoremap <c-s> <c-\><c-n>

nmap <silent> <leader>ti :tabnew<bar>terminal<cr>:startinsert!<cr>
nmap <silent> <leader>vi :vertical new<bar>terminal<cr>:startinsert<cr>
nmap <silent> <leader>ni :new<bar>terminal<cr>:startinsert<cr>
" }}}
" {{{ --| Movement |----------------------------------------
" Marks
noremap ' `
noremap ` '
noremap <silent> <leader>m :delmarks!<cr>
" Beginning / end of the line
inoremap <c-a> <c-o>^
cnoremap <c-a> <home>
inoremap <c-e> <c-o>$
cnoremap <c-e> <end>
nmap ç ^
" Split lines
noremap <c-j> i<cr><esc>
" Don't make a # force column zero.
inoremap # X<bs>#
" Fuck you, help.
nnoremap <F1> <nop>
inoremap <F1> <nop>
" Clever paste from system buffer
noremap <leader>p "+p
noremap <leader>P "+P
noremap <leader>y "+y
nnoremap yf :<c-u>let @+ = expand("%")<cr>:echo 'File name yanked.'<cr>
" Give a more logical behavior to Y
nnoremap Y y$
" Visual yank
vnoremap y ygv<esc>
vnoremap Y Ygv<esc>
" select the whole line
nnoremap vv ^v$h
" Command line
noremap è :
noremap È :!
" Find character
nnoremap , ;
nnoremap ; ,
vnoremap , ;
vnoremap ; ,
" block
nmap <m-t> }
nmap <m-s> {
" }}}
" {{{ --| Mode Switching |----------------------------------
" Close current buffer
nnoremap Q :bdelete!<cr>
" Normal mode
cnoremap <esc> <c-c>
" Exit
nnoremap à :confirm quit<cr>
nnoremap À :confirm quitall<cr>
" Save
nnoremap <c-s> :w<cr>
inoremap <c-s> <esc>:w<cr>
vnoremap <c-s> <esc>:w<cr>
" Reselect pasted lines
nnoremap gV `[v`]
" }}}
" {{{ --| Togglers |----------------------------------------
" Rename file
command! RenameFile :call RenameFile()
command! RF :call RenameFile()
" Toggle highlight current word
nmap <leader>' :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
" Uppercase current word
nmap <c-g> gUiw
imap <c-g> <esc>gUiwea
" Clear trailing spaces (but not the escaped ones)
function! ClearTrailingSpaces()
  let l:_s=@/
  %substitute/\v(^\s+$|[\\]\s\zs\s+$|[^\\]\zs\s+$)//e
  let @/=l:_s
  nohl
endfunction
nmap <silent> <leader>k m`:call ClearTrailingSpaces()<cr>g``
" Fix indent
nmap <silent> ga m`gg=G:call ClearTrailingSpaces()<cr>g``
" Cursorline / Cursorcolumn
function! AlignMode()
  if &virtualedit ==# 'all'
    setlocal virtualedit=""
  else
    setlocal virtualedit=all
  end
  setlocal cursorcolumn!
  setlocal cursorline!
endfunction
nmap <leader>g :call AlignMode()<cr>
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
noremap 7 :GitGutterStageHunk<cr>
noremap - 8
noremap 8 :GitGutterUndoHunk<cr>
noremap / 9
noremap 9 /
noremap * 0
noremap 0 *
" }}}
" {{{ --| Search & Replace |--------------------------------
noremap é /
" Hide search matches upon hitting <esc> in normal mode
nnoremap <silent> <esc> <esc>:nohlsearch<cr><c-l>

nmap <silent> <leader>é :set operatorfunc=UsageOperator<cr>g@iw
vmap <silent> <leader>é :<c-u>call UsageOperator(visualmode())<cr>
nmap <silent> <leader>É :set operatorfunc=DefinitionOperator<cr>g@iw

nnoremap É :%s/
vnoremap É <esc>:%s/\%V

nmap <A-n> :lnext<cr>
nmap <A-p> :lprev<cr>

command! NONASCII /[^\x00-\x7F]
" }}}
" {{{ --| Quick Editing |-----------------------------------
function! MaybeTabedit(filename)
  let l:cmd = (expand('%') ==# '') ? 'edit' : 'tabedit'
  execute 'silent ' . l:cmd . ' ' . a:filename
endfunction

function! OpenSchemaFile()
  if filereadable('db/structure.sql')
    call MaybeTabedit('db/structure.sql')
  else
    call MaybeTabedit('db/schema.rb')
  endif
endfunction

nmap <leader>es :call OpenSchemaFile()<cr>

nmap <leader>ea :call MaybeTabedit('~/httpclient.rest')<cr>
nmap <leader>ee :call MaybeTabedit('~/.scratchpad.md')<cr>
nmap <leader>ei :call MaybeTabedit('~/poi.md')<cr>
nmap <leader>ep :call MaybeTabedit('~/postgres.sql')<cr>
nmap <leader>eq :call MaybeTabedit('~/sqlite.sql')<cr>
nmap <leader>eu :UltiSnipsEdit<space>
nmap <leader>ev :call MaybeTabedit('.nvimrc')<cr>

nmap <leader>. :Texplore .<cr>

nmap <leader># :e #<cr>

" Source local .nvimrc
nmap <silent>
      \ <leader>$
      \ :source .nvimrc<bar>let &filetype=&filetype<cr>
      \ :echom 'local .nvimrc sourced'<cr>
" }}}
" {{{ --| Convenience Mapping |-----------------------------
vmap <leader>s :sort<cr>

noremap <silent> <leader><leader> @q
vnoremap <silent> <leader><leader> :normal 6q<cr>
" }}}
" }}}
