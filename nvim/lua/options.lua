local home = os.getenv("HOME")

local o = vim.opt

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
o.listchars = { tab = '› ', trail = '·', nbsp = ' ', extends = '»', precedes = '«' }
-- encoding and filetype
o.fileformats = 'unix,dos,mac'
-- undo, backup and swap files
o.undodir = { home .. '/.tmp//' }
o.backupdir = { home .. '/.tmp//' }
o.directory = { home .. '/.tmp//' }
-- activate undofile, that holds undo history
o.undofile = true
-- ignore those files
o.wildignore:append('*/tmp/*,*.so,*.swp,*.zip,*.pyc,tags')
-- case insensitive matching
o.wildignorecase = true
-- ctags
o.tags = '.tags,./.tags,./tags,tags'
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
