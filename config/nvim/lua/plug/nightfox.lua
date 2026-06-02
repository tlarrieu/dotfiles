vim.pack.add({ 'https://github.com/edeneast/nightfox.nvim' }, { confirm = false })

local file_for = function(mode)
  return vim.fs.joinpath(vim.fn.stdpath('config'), 'lua', 'colors', mode .. '.lua')
end

local import = function(mode)
  return loadfile(file_for(mode))()
end

local setup = function()
  require('nightfox').setup({
    palettes = {
      dawnfox = import('light'),
      nordfox = import('dark'),
    },
    groups = { all = require('colors.theme') },
  })
end

local apply_mode = function()
  vim.o.background = require('mode').current()
  setup()
  vim.cmd.colorscheme(vim.o.background == 'light' and 'dawnfox' or 'nordfox')
end

vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    setup()
    if not vim.g.colors_name then return end

    local ok, palette = pcall(require, 'nightfox.palette')
    if not ok then return end

    palette = palette.load(vim.g.colors_name)

    local devicons
    ok, devicons = pcall(require, 'nvim-web-devicons')
    if not ok then return end

    devicons.set_default_icon('', palette.fg.dim, 0)
  end,
})
vim.api.nvim_create_autocmd('Signal', { pattern = { 'SIGUSR1' }, callback = apply_mode, nested = true })

apply_mode()
