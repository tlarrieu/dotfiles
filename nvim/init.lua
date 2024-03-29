-- vim:fdm=marker
-- -----------------------------------------------------------------------------
-- tlarrieu's nvim.lua
-- Designed for dvorak-bépo keyboard
-- -----------------------------------------------------------------------------

vim.g.mapleader = " "

-- get lazy.nvim if not present
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup('plugins')

require('mappings')
require('options')
require('globals')
require('autocmd')
