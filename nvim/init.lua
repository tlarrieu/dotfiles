require('usr.options')

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  spec = { import = 'plugins' },
  install = { colorscheme = { 'evening' } },
  change_detection = { notify = false },
  ui = {
    border = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
  },
})

require('usr.filetypes')
require('usr.keymaps')
require('usr.abbrev')
require('usr.autocmd')
