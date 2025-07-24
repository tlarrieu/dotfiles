vim.g.mapleader = ' '

-- {{{ ==| General options |====================================================
vim.opt.shell = '/usr/bin/fish'
-- allow project specific .nvim.lua
vim.opt.exrc = true
vim.opt.secure = true
-- line numbering
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.textwidth = 120
-- termguicolors
vim.opt.termguicolors = true
-- blank characters
vim.opt.list = true
vim.opt.listchars = { tab = '› ', trail = '·', nbsp = '⎵', extends = '»', precedes = '«' }
-- encoding and filetype
vim.opt.fileformats = 'unix,dos,mac'
-- undo, backup and swap files
vim.opt.undodir = { os.getenv("HOME") .. '/.tmp//' }
vim.opt.backupdir = { os.getenv("HOME") .. '/.tmp//' }
vim.opt.directory = { os.getenv("HOME") .. '/.tmp//' }
-- activate undofile, that holds undo history
vim.opt.undofile = true
-- ignore those files
vim.opt.wildignore:append('*/tmp/*,*.so,*.swp,*.zip,*.pyc,tags')
-- case insensitive matching
vim.opt.wildignorecase = true
-- ctags
vim.opt.tags = '.tags,./.tags,./tags,tags'
-- mouse
vim.opt.mouse = 'a'
-- command completion style
vim.opt.wildmode = 'list:full,full'
vim.opt.complete = '.,w,b,u,t,i'
-- set title when in console
vim.opt.title = true
-- disable line wrap
vim.opt.wrap = false
-- line wrap at word boundaries
vim.opt.linebreak = true
-- indent soft-wrapped lines
vim.opt.breakindent = true
-- define character indicating line wrap
vim.opt.showbreak = '↪ '
-- update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
-- signcolumn
vim.opt.signcolumn = 'yes:1'
-- }}}

-- {{{ ==| Statusline |=========================================================
vim.opt.laststatus = 3
vim.opt.showmode = false
-- }}}

-- {{{ ==| Splits |=============================================================
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.fillchars:append('eob: ')
-- }}}

-- {{{ ==| Scrolling |==========================================================
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 15
vim.opt.sidescroll = 1
-- }}}

-- {{{ ==| Indent |=============================================================
vim.opt.smartindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.shiftround = true
-- }}}

-- {{{ ==| Searching |==========================================================
vim.opt.ignorecase = true
vim.opt.smartcase = true
local file = io.open('.ignore', 'r')
if file then
  vim.opt.grepprg = "rg --smart-case --vimgrep --hidden --no-ignore-vcs '$*'"
else
  vim.opt.grepprg = "rg --smart-case --vimgrep --hidden '$*'"
end
-- }}}

-- {{{ ==| Spell checking |=====================================================
vim.opt.spelllang = 'en,fr'
-- }}}

-- {{{ ==| Short message |======================================================
vim.opt.shortmess:append('WIcsSa')
-- }}}

-- {{{ ==| diagnostic |=========================================================
vim.diagnostic.config({
  virtual_text = {
    prefix = '▰',
    source = true,
    spacing = 0,
  },
  float = {
    source = true,
  },
  signs = false,
  underline = true,
})
-- }}}
