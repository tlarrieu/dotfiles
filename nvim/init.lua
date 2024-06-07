package.path = package.path .. ';/home/tlarrieu/scripts/?.lua'

vim.g.mapleader = ' '

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

require('lazy').setup('plugins')

require('usr/keymaps')
require('usr/options')
require('usr/globals')
require('usr/abbrev')
require('usr/autocmd')
