local o = vim.opt
local home = os.getenv("HOME")

-- {{{ ==| General options |====================================================
-- shell
o.shell = '/bin/sh'
-- allow project specific init.lua
o.exrc = true
o.secure = true
-- never show mode
o.showmode = false
-- line numbering
o.relativenumber = true
o.number = true
o.textwidth = 80
-- blank characters
o.list = true
o.listchars = 'tab:› ,trail:·,nbsp:¬,extends:»,precedes:«'
-- encoding and filetype
o.fileformats = 'unix,dos,mac'
-- undo, backup and swap files
o.undodir = home .. '/.tmp//'
o.backupdir = home .. '/.tmp//'
o.directory = home .. '/.tmp//'
-- activate undofile, that holds undo history
o.undofile = true
-- ignore those files
o.wildignore:append('*/tmp/*,*.so,*.swp,*.zip,*.pyc,tags')
-- case insensitive matching
o.wildignorecase = true
-- ctags
tags = '.tags,./.tags,./tags,tags'
-- mouse
o.mouse = 'a'
-- command completion style
o.wildmode = 'list:full,full'
o.complete = '.,w,b,u,t,i'
-- allow a modified buffer to be sent to background without saving it
o.hidden = true
-- set title when in console
o.title = true
-- disable line wrap
o.wrap = false
-- line wrap at word boundaries
o.linebreak = true
-- indent soft-wrapped lines
o.breakindent = true
-- define character indicating line wrap
o.showbreak = '↪ '
-- do not insert spaces after '.', '?' and '!' when joining lines
o.joinspaces = false
-- do not redraw screen while running macros
o.lazyredraw = true
-- update time
o.updatetime = 250
-- inccommand
o.inccommand = 'nosplit'
o.signcolumn = 'auto:2-9'
-- }}}
-- {{{ ==| Splits |=============================================================
o.splitright = true
o.splitbelow = true
o.fillchars:append('vert: ')
o.fillchars:append('eob: ')
-- }}}
-- {{{ ==| Scrolling |==========================================================
o.scrolloff = 8
o.sidescrolloff = 15
o.sidescroll = 1
-- }}}
-- {{{ ==| Indent |=============================================================
o.smartindent = true
o.tabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.shiftround = true
-- }}}
-- {{{ ==| Folding |============================================================
o.foldcolumn = '0'
o.foldclose = ''
o.foldmethod = 'indent'
o.foldnestmax = 3
o.foldlevelstart = 10
o.fillchars:append('fold: ')
o.foldminlines = 1
o.foldtext = 'FoldText()'
-- }}}
-- {{{ ==| Searching |==========================================================
-- case behavior regarding searching
o.ignorecase = true
o.smartcase = true
-- }}}
-- {{{ ==| Spellchecking |======================================================
o.spelllang = 'en,fr'
-- }}}
-- {{{ ==| Statusline |=========================================================
o.statusline=''
o.statusline:append('%*')
-- path
o.statusline:append('%f ')
o.statusline:append('%(%{statusline#Readonly()} %)')
o.statusline:append('%(%{statusline#Modified()} %)')
o.statusline:append('%(%{statusline#Paste()} %)')
-- align right
o.statusline:append('%*%= %*')
o.statusline:append('%#warningmsg#')
o.statusline:append('%(%{statusline#Whitespace()} %)')
o.statusline:append('%*')
-- file type
o.statusline:append('%(%y %)')
-- line and column
o.statusline:append('(%l,%c) ')
-- percentage of file
o.statusline:append('%P ')
o.statusline:append('%*')
-- }}}
-- {{{ ==| Shortmess |=========================================================
o.shortmess:append('WI')
-- }}}

-- {{{ ==| Plugins |=============================================================
vim.cmd([[
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
  \ 'path': '~/.vimwiki/home/d&d-campaign',
  \ 'syntax': 'markdown',
  \ 'ext': '.md'
  \ },
  \ {
  \ 'path': '~/.vimwiki/work',
  \ 'syntax': 'markdown',
  \ 'ext': '.md'
  \ }]
" }}}
" {{{ --| Bullets |-----------------------------------------
let g:bullets_set_mappings = 0
" }}}
" {{{ --| vim-test |----------------------------------------
let g:test#strategy = 'neoterm'
" }}}
" {{{ --| HighlightedYank |---------------------------------
let g:highlightedyank_highlight_duration = 180
" }}}
" {{{ --| Neoterm |-----------------------------------------
let g:neoterm_default_mod = 'botright'
let g:neoterm_autoscroll = 1
let g:neoterm_size = 12
let g:neoterm_automap_keys = '<space>vttttt'
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
" {{{ --| GitGutter |---------------------------------------
let g:gitgutter_map_keys = 0
" }}}
" {{{ --| FZF |---------------------------------------------
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
  \ 'text': '✖',
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
" {{{ --| Angry |-------------------------------------------
let g:angry_disable_maps = 1
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
" }}}
]])
-- }}}
