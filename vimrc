" vim:fdm=marker
" ------------------------------------------------------------------------------
" tlarrieu's vimrc
" Designed for dvorak-bépo keyboard
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

" -- | Vundle | -----------------------
Plugin 'gmarik/Vundle.vim'
" -- | File Manipulation | ------------
Plugin 'kien/ctrlp.vim'
Plugin 'rking/ag.vim'
Plugin 'skwp/greplace.vim'
" -- | Functionnalities | -------------
Plugin 'tpope/vim-dispatch'
Plugin 'beloglazov/vim-online-thesaurus'
" -- | Snippets | ---------------------
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
" -- | Project config | ---------------
Plugin 'tpope/vim-projectionist'
" -- | Text manipulation | ------------
Plugin 'Valloric/YouCompleteMe'
Plugin 'AndrewRadev/switch.vim'
Plugin 'tpope/vim-commentary'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'edsono/vim-matchit'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
" -- | Text objects | -----------------
Plugin 'kana/vim-textobj-user'
Plugin 'michaeljsmith/vim-indent-object'
Plugin 'nelstrom/vim-textobj-rubyblock'
Plugin 'wellle/targets.vim'
Plugin 'haya14busa/incsearch.vim'
Plugin 'tommcdo/vim-exchange'
Plugin 'kana/vim-textobj-function'
" -- | Task manager | -----------------
Plugin 'samsonw/vim-task'
" -- | Undo tree explorer | -----------
Plugin 'sjl/gundo.vim'
" -- | List toggler | -----------------
Plugin 'milkypostman/vim-togglelist'
" -- | Buffer functionnalities | ------
Plugin 'duff/vim-bufonly'
Plugin 'roman/golden-ratio'
" -- | Ruby | -------------------------
Plugin 'janko-m/vim-test'
Plugin 'vim-ruby/vim-ruby'
Plugin 'Keithbsmiley/rspec.vim'
Plugin 'tpope/vim-rails'
" -- | HTML | -------------------------
Plugin 'mattn/emmet-vim'
" -- | Haskell | ----------------------
Plugin 'twinside/vim-syntax-haskell-cabal'
Plugin 'bitc/vim-hdevtools'
" -- | Go lang | ----------------------
Plugin 'fatih/vim-go'
" -- | SQL | --------------------------
Plugin 'ivalkeen/vim-simpledb'
Plugin 'exu/pgsql.vim'
" -- | Markdown | ---------------------
Plugin 'gabrielelana/vim-markdown'
Plugin 'greyblake/vim-preview'
" -- | Misc languages support | -------
Plugin 'vim-scripts/fish-syntax'
Plugin 'roalddevries/yaml.vim'
Plugin 'lmeijvogel/vim-yaml-helper'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'kchmck/vim-coffee-script'
Plugin 'tpope/vim-haml'
Plugin 'chrisbra/csv.vim'
" -- | VCS | --------------------------
Plugin 'tpope/vim-fugitive'
Plugin 'phleet/vim-mercenary'
Plugin 'zeekay/vim-lawrencium'
Plugin 'mhinz/vim-signify'
" -- | Syntax checking | --------------
Plugin 'scrooloose/syntastic'
" -- | Good looking | -----------------
Plugin 'altercation/vim-colors-solarized'
Plugin 'bling/vim-airline'
Plugin 'kshenoy/vim-signature'
Plugin 'vim-scripts/AnsiEsc.vim'
Plugin 'reedes/vim-thematic'
" -- | Colors | -----------------------
Plugin 'KabbAmine/vCoolor.vim'              " Picker
Plugin 'chrisbra/Colorizer'                 " Highlighter

call vundle#end()

" Force loading of solarized before everything else so we can override
" a few things without using BufPostRead / BufEnter shenanigans
runtime! bundle/vim-colors-solarized/colors/solarized.vim

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
    set ignorecase
    au! auto_highlight
    augroup! auto_highlight
    setl updatetime=4000
    echo 'Highlight current word: OFF'
    return 0
  else
    set noignorecase
    augroup auto_highlight
      au!
      au CursorMoved * let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
    augroup end
    let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
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
  autocmd BufReadPost COMMIT_EDITMSG startinsert!
  autocmd FileType vim setlocal foldlevel=10
  autocmd FileType vim setlocal foldmethod=marker
  autocmd FileType vim setlocal foldminlines=1
  autocmd FileType html,eruby setlocal foldlevel=10
  autocmd FileType html setlocal foldmethod=syntax
  autocmd FileType html setlocal foldminlines=1
  autocmd BufReadPost *.yml set ft=yaml
  " Only current splits gets cursor line / column highlighted
  autocmd WinLeave * set nocursorline
  autocmd WinLeave * set nocursorcolumn
  autocmd WinEnter * set cursorline
  autocmd WinEnter * set cursorcolumn
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
" {{{ ---------------------------------------------------------- General options
set history=500
" Color / background theme
set background=light
colorscheme solarized
if has('gui_running')
  set guifont=Fira\ Mono\ for\ Powerline:h15
  set guioptions-=l
  set guioptions-=L
  set guioptions-=r
  set guioptions-=R
  set guioptions-=b
  set guicursor+=n-v-c-i:ver11-iCursor
  hi! iCursor guifg=white guibg=#667B83
endif
hi! link SignColumn LineNr
" Line numbering (relative and current)
set rnu
set nu
" Line length warning (disabled for now)
highlight OverLength ctermbg=red ctermfg=black guibg=red guifg=black
augroup overlength
  au!
  autocmd FileType man hi! link OverLength Normal
augroup END
match OverLength /\%86v.\+/
" Virtual editing
set virtualedit=all
" Blank character
set lcs=tab:\›\ ,trail:·,nbsp:¬,extends:»,precedes:«
set showbreak= 
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
" set complete=slf
set complete=.,w,b,u,t,i
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
" Do not redraw screen while running macros
set lazyredraw
" Improve redrawing
set ttyfast
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
hi! Search ctermbg=7 ctermfg=2 guifg=#719e07
hi! IncSearch ctermbg=7 ctermfg=5 guifg=#d33682
hi! IncSearchMatch ctermbg=7 ctermfg=5 cterm=reverse guibg=#d33682 guifg=#ffffff
" }}}
" {{{ ------------------------------------------------------------ Spellchecking
set spelllang=en,fr
" }}}
" {{{ ------------------------------------------------------------------ Plugins
" {{{ -------------------------------- Golden Ratio
let g:golden_ratio_exclude_nonmodifiable = 1
" }}}
" {{{ ----------------------------------- Thesaurus
nnoremap gh :OnlineThesaurusCurrentWord<CR>
nnoremap gH :Thesaurus<space>
" }}}
" {{{ ------------------------------------ Exchange
let g:exchange_no_mappings=1
nmap lx <Plug>(Exchange)
vmap X <Plug>(Exchange)
nmap lxl <Plug>(ExchangeClear)
nmap lxx <Plug>(ExchangeLine)
" }}}
" {{{ --------------------------------------- Emmet
let g:user_emmet_leader_key=','
let g:use_emmet_complete_tag = 1
let g:user_emmet_install_global = 0
let g:user_emmet_settings = {
\  'indentation' : '  '
\}
augroup emmet
  au!
  au FileType html,css,scss,eruby EmmetInstall
augroup end
" }}}
" {{{ ------------------------------------- BufOnly
nnoremap <leader>B :BufOnly<cr>
" }}}
" {{{ ------------------------------------ Markdown
let g:markdown_enable_mappings = 0
" }}}
" {{{ ------------------------------------ SimpleDB
let g:sql_type_default = 'mysql'
let g:omni_sql_no_default_maps = 1
augroup SQL
  autocmd!
  autocmd BufRead vim-simpledb-result.txt setf sql
augroup end
" }}}
" {{{ ----------------------------------- Signature
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
  \ 'GotoNextLineByPos'  :  "n,",
  \ 'GotoPrevLineByPos'  :  "N,",
  \ 'GotoNextSpotByPos'  :  "",
  \ 'GotoPrevSpotByPos'  :  "",
  \ 'GotoNextMarker'     :  "",
  \ 'GotoPrevMarker'     :  "",
  \ 'GotoNextMarkerAny'  :  "",
  \ 'GotoPrevMarkerAny'  :  "",
  \ 'ListLocalMarks'     :  ""
  \ }
" }}}
" {{{ ------------------------------------- vCoolor
noremap <leader>C :<c-u>VCoolor<cr>
noremap <leader>c :ColorToggle<cr>
" }}}
" {{{ ------------------------------------- endwise
autocmd FileType elixir
  \ let b:endwise_addition = 'end' |
  \ let b:endwise_words = 'do' |
  \ let b:endwise_pattern = '\<do\ze\s*$' |
  \ let b:endwise_syngroups = 'elixirKeyword'
" }}}
" {{{ ---------------------------------------- YAML
augroup yaml
  au!
  autocmd FileType yaml nnoremap <buffer> 6 :YamlGoToKey<space>
  autocmd FileType yaml nnoremap <buffer> 7 :YamlGoToParent<cr>
  autocmd FileType yaml nnoremap <buffer> 8 :YamlGetFullPath<cr>
augroup end
" }}}
" {{{ ---------------------------------- ToggleList
 let g:toggle_list_copen_command="copen"
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
nnoremap <leader>f :Dispatch<cr>
nnoremap <leader>F :<c-u>Focus  %<left><left>
" }}}
" {{{ ------------------------------------ vim-test
let g:test#strategy = 'dispatch'
" }}}
" {{{ ------------------------------------- Targets
let g:targets_pairs = '()b {}é []d <>É'
let g:targets_argTrigger = 'c'
" By default, we want to delete only the ACTUAL parameter
" Not the whitespaces around it
omap ic Ic
let g:targets_argOpening = '[({[]'
let g:targets_argClosing = '[]})]'
" }}}
" {{{ ----------------------------------- Syntastic
let g:syntastic_javascript_checkers = ['jsl']
let g:syntastic_ruby_checkers = ['mri']
let g:syntastic_javascript_ruboconf_conf = "~/.rubocop.yml"
let g:syntastic_ruby_rubocop_args = '-D'
let g:syntastic_haskell_checkers = ['hdevtools', 'hlint']
augroup lint
  au!
  au FileType ruby noremap <buffer> <leader>L :SyntasticCheck rubocop<cr>
  au FileType scss noremap <buffer> <leader>L :SyntasticCheck scss_lint<cr>
augroup end
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
" }}}
" {{{ ------------------------------------ Greplace
set grepprg=ag\ --line-numbers\ --noheading
nnoremap <leader>A :Gqfopen<cr>
nnoremap <leader>R :Greplace<cr>
" }}}
" {{{ ------------------------------------------ Ag
let g:ag_apply_qmappings = 0
let g:ag_apply_lmappings = 0
let g:agprg = "ag --column --line-numbers --noheading --smart-case"

augroup Ag
  autocmd!
  autocmd BufReadPost quickfix nnoremap <silent> <buffer> <nl> <C-W><CR><C-W>T
  autocmd BufReadPost quickfix nnoremap <silent> <buffer> <c-cr> <C-W><CR><C-W>T
  autocmd BufReadPost quickfix nnoremap <silent> <buffer> <C-v> <C-W><CR><C-W>H<C-W>b<C-W>J<C-W>t
  autocmd BufReadPost quickfix setlocal nonu
  autocmd BufReadPost quickfix setlocal nornu
augroup END

nnoremap <leader>a :Ag! ""<left>
nnoremap yu :set operatorfunc=<SID>UsageOperator<cr>g@iw
vnoremap yu :<c-u>call <SID>UsageOperator(visualmode())<cr>
nnoremap yd :set operatorfunc=<SID>DefinitionOperator<cr>g@iw

augroup quickfix
  au!
  au FileType qf call AdjustWindowHeight(3, 20)
augroup END
function! AdjustWindowHeight(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction
" }}}
" {{{ ----------------------------------- UltiSnips
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsJumpForwardTrigger="<c-t>"
let g:UltiSnipsJumpBackwardTrigger="<c-s>"
noremap <leader>use :UltiSnipsEdit<cr>
" }}}
" {{{ -------------------------------- YouCompletMe
let g:ycm_key_list_select_completion = ['<c-n>']
let g:ycm_key_list_previous_completion = ['<c-p>']
" Enable omni completion.
augroup omnicomp
  au!
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
  autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
  autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading=1
  autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global=1
augroup END
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
xmap S   <Plug>VSurround
xmap gS  <Plug>VgSurround
" }}}
" {{{ --------------------------------------- CtrlP
let g:ctrlp_map = '<space>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_switch_buffer = 'ET'
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:20,results:40'
let g:ctrlp_open_new_file = 't'
if executable('ag')
  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif
nnoremap <leader><leader> :CtrlPBufTag<cr>
nnoremap <leader>; :CtrlPTag<cr>
nnoremap   :CtrlPBuffer<cr>
nnoremap <backspace> :<c-u>CtrlPClearCache<cr>
  let g:ctrlp_prompt_mappings = {
    \ 'PrtSelectMove("j")':   ['<c-t>', '<down>'],
    \ 'PrtSelectMove("k")':   ['<c-s>', '<up>'],
    \ 'AcceptSelection("h")': ['<c-x>'],
    \ 'AcceptSelection("t")': ['<c-cr>', '<nl>', '<c-j>'],
    \ }
hi! CtrlPMatch ctermfg=5 guifg=#d33682
" }}}
" {{{ --------------------------------------- Gundo
let gundo_map_move_older = "t"
let gundo_map_move_newer = "s"
noremap <leader>gu :GundoToggle<cr>
" }}}
" {{{ ------------------------------------- Signify
let g:signify_vcs_list = [ 'hg', 'git' ]
let g:signify_update_on_focusgained = 1
" }}}
" {{{ ----------- Fugitive / Mercenary / Lawrencium
function! HgBranchStatus()
  silent tabnew /dev/null
  normal ggdG
  0read !hg status --rev "::. - ::default" -n
  silent :w
endfunction

function! SwitchVCS()
  if g:next_vcs ==# 'mercurial'
    noremap <leader>S :call HgBranchStatus()<cr>
    noremap <leader>s :Hgstatus<cr>
    noremap <leader>D :HGdiff ancestor(default,.)<cr>
    noremap <leader>b :HGblame<cr>
    noremap <leader>d :HGdiff<cr>
    noremap <leader>r :Hgrevert!<cr>:e<cr>
    let g:next_vcs = 'git'
  else
    noremap <leader>b :Gblame<cr>
    noremap <leader>d :Gvdiff<cr>
    noremap <leader>r :Gread<cr>
    noremap <leader>s :Gstatus<cr>
    let g:next_vcs = 'mercurial'
  endif
endfunction

let g:next_vcs = 'mercurial'
call SwitchVCS()
nnoremap <leader><tab> :call SwitchVCS()<cr>
" {{{ ------------------------------------------------- Various keyboard mapping
" {{{ --------------------------------------- Rails
noremap <leader>x :Rextract<space>
" }}}
" {{{ --------------------------------- Exercism.io
nnoremap <silent> <leader>xf :Dispatch exercism f<cr>
nnoremap <silent> <leader>xs :Dispatch exercism s %<cr>
" }}}
" {{{ ------------------------------------- Buffers
" Empty buffers
command! B bufdo bd
function! DeleteHiddenBuffers()
  let tpbl=[]
  call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
  for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
    silent execute 'bwipeout' buf
  endfor
endfunction
noremap <leader>. :call DeleteHiddenBuffers()<cr>
" }}}
" {{{ ------------------------------- Splits / Tabs
noremap <c-w>O :tabo<cr><c-w>o
noremap <c-w><c-c> <c-w>H
noremap <c-w><c-t> <c-w>J
noremap <c-w><c-s> <c-w>K
noremap <c-w><c-r> <c-w>L
" Vertical split
noremap <leader>v :vnew <c-r>=escape(expand("%:p:h"), ' ') . '/'<cr>
" Navigating between splits
nnoremap <tab> <c-w>w
nnoremap <s-tab> <c-w>W
nnoremap <c-b> <c-i>
nnoremap S gT
nnoremap T gt
" Resize splits
map <Up>    <c-w>+
map <Down>  <c-w>-
map <Left>  <c-w><
map <Right> <c-w>>
map <leader>m <c-w>=
noremap <leader>M :res<cr>:vertical res<cr>$
" New tab
noremap <leader>tt :tabe<cr>
noremap <leader>te :tabe <c-r>=escape(expand("%:p:h"), ' ') . '/'<cr>
" Close current tab
noremap <leader>tc :tabclose<cr>
" Close all tabs but current
noremap <leader>to :tabo<cr>

" Merge a tab into a split in the previous window
function! MergeTabs()
  if tabpagenr() == 1
    return
  endif
  let bufferName = bufname("%")
  if tabpagenr("$") == tabpagenr()
    close!
  else
    close!
    tabprev
  endif
  execute "vs " . bufferName
endfunction

" Unmerge a split into a new tab
function! UnmergeWindow()
  let bufferName = bufname("%")
  close!
  execute "tabe " . bufferName
endfunction

noremap <leader>U :call UnmergeWindow()<cr>
noremap <leader>uu :call MergeTabs()<cr>
" }}}
" {{{ ------------------------------------ Movement
" Quickfix errors
noremap <c-n> :cnext<cr>
noremap <c-p> :cprev<cr>
" Diffs
nmap <c-t> ]c
nmap <c-s> [c
" Command line / Search
cmap <c-t> <down>
cmap <c-s> <up>
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
" Beginning of line
nnoremap C ^
vnoremap C ^
" End of line
nnoremap R $
vnoremap R $
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
" Till
noremap è t
noremap È T
" }}}
" {{{ ------------------------------ Mode Switching
" Yank (necessary because of some custom bindings for ag)
vnoremap yy y
" Swap command and repeat keys
noremap . :
noremap : .
" Necessary hack to make repeat work as expected (since we swapped . and :)
nnoremap <silent> : :<c-u>call repeat#run(v:count)<cr>
" save
noremap $ :w<cr>
" Normal mode + save
noremap <c-c> <esc>
" Leave the cursor in place after leaving insert mode
inoremap <c-c> <esc>`^
vnoremap <c-c> <esc>
xnoremap <c-c> <esc>
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
" Reselected pasted lines
nnoremap <leader>V V`]
" Select current line charwise
nnoremap vv ^v$
" }}}
" {{{ ------------------------------------ Togglers
" Rename file
command! RenameFile :call RenameFile()
command! RF :call RenameFile()
noremap <leader>n :call RenameFile()<cr>
" Quickfix / Location togglers
noremap <silent> <leader>q :call ToggleQuickfixList()<cr>
noremap <silent> <leader>l :call ToggleLocationList()<cr>
" Toggle highlight current word
noremap <leader>' :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
" Clear search
noremap <silent> H :let @/ = ""<cr>
" Toggle line wrap
nnoremap <leader>w :set wrap!<cr>
nnoremap U :redo<cr>
" Split swap
nnoremap <c-k> :call SplitSwap()<cr><c-w><c-w>
" Uppercase current word
nnoremap <c-g> gUiw
inoremap <c-g> <esc>gUiwea
" Clear trailing spaces
nnoremap <silent> <leader>k :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
" Fix indent
nnoremap <silent> <leader>i mmgg=G`m
" }}}
" {{{ ---------------------------- Swap number line
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
noremap 8 :Switch<cr>
noremap / 9
noremap 9 /
noremap * 0
noremap 0 *
" }}}
" {{{ ---------------------------- Search & Replace
map é <Plug>(incsearch-stay)
map É <Plug>(incsearch-forward)
map ' <plug>(incsearch-nohl-n)
map ? <plug>(incsearch-nohl-N)

noremap <leader>é :%s/
noremap <leader>É :s/
vnoremap <leader>é <esc>:%s/\%V/g<left><left>

noremap n `
noremap nn ``
" }}}
" {{{ ------------------------------- Quick Editing
" Rails
nnoremap <leader>es :tabe db/structure.sql<cr>

nnoremap <leader>ev :tabe $MYVIMRC<cr>
nnoremap <leader>eg :tabe ~/.gitconfig<cr>
nnoremap <leader>eh :tabe ~/.hgrc<cr>
nnoremap <leader>ef :tabe ~/.config/fish/config.fish<cr>
nnoremap <leader>em :tabe ~/.tmux.conf<cr>
nnoremap <leader>et :tabe ~/todo.tasks<cr>
nnoremap <leader>er :tabe ~/release.tasks<cr>
nnoremap <leader>ep :tabe ~/postgres.sql<cr>
nnoremap <leader>eq :tabe ~/sqlite.sql<cr>
nnoremap <leader>eo :tabe ~/poi.md<cr>
" }}}
" {{{ ------------------------- Ranger File Chooser
nnoremap <leader>h :<c-u>RangerChooser<CR>
nnoremap <leader>H :<c-u>RangerChooserRoot<CR>
" }}}
" {{{ ------------------------- Convenience Mapping
vnoremap <leader>s :sort<cr>
" {{{ --------------------------- Utility Functions
" This function extracts a pattern from the whole buffer and replaces it
" with a line for each match on a single line
function! Extract()
  let @z=""
  %s//\=setreg('Z', submatch(0), 'l')/g
  %d _
  pu z
  0d _
endfunction
command! Extract silent call Extract()

" Enforce UTF8
function! UTF8()
  execute ':set fileencoding=utf8'
  execute ':set fileformat=unix'
  execute ':w'
endfunction
command! UTF8 :call UTF8()

" Convert Rails interpolated variable to Mailchimp format
function! ToMailchimp()
  :%s/<%= \?\(.\{-}\) \?%>/*|\1|*/g
endfunction
command! Mailchimp :silent call ToMailchimp()

" Convert Rails interpolated variable to Handlebar format
function! ToMustach()
  :%s/<%= \?\(.\{-}\) \?%>/\{\{\1}}/g
endfunction
command! Mustach :silent call ToMustach()

function! ClearRegisters()
  let regs='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-="*+'
  let i=0
  while (i<strlen(regs))
    exec 'let @'.regs[i].'=""'
    let i=i+1
  endwhile
endfunction
command! ClearRegisters call ClearRegisters()

function! Redir(command)
  redir! >/tmp/vim_redir
  silent exec a:command
  redir END
  r /tmp/vim_redir
endfunction
command! -nargs=1 R call Redir(<q-args>)
" }}}
" }}}
