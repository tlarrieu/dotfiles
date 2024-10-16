local home = os.getenv("HOME")

local o = vim.opt

-- {{{ ==| General options |====================================================
-- allow project specific .nvim.lua
o.exrc = true
o.secure = true
-- line numbering
o.relativenumber = true
o.number = true
o.textwidth = 120
-- blank characters
o.list = true
o.listchars = { tab = '› ', trail = '·', nbsp = '⎵', extends = '»', precedes = '«' }
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
-- update time
o.updatetime = 250
-- signcolumn
o.signcolumn = 'auto:1-2'
-- }}}

-- {{{ ==| Statusline |=========================================================
o.laststatus = 3
o.showmode = false
-- }}}

-- {{{ ==| Splits |=============================================================
o.splitright = true
o.splitbelow = true
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

-- {{{ ==| Searching |==========================================================
o.ignorecase = true
o.smartcase = true
-- }}}

-- {{{ ==| Spell checking |=====================================================
o.spelllang = 'en,fr'
-- }}}

-- {{{ ==| Short message |======================================================
o.shortmess:append('WIcsa')
-- }}}

-- {{{ ==| diagnostic |=========================================================
vim.diagnostic.config({
  virtual_text = true,
  signs = false,
  underline = true,
})
-- }}}
