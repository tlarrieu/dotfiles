vim.pack.add({ 'https://github.com/edeneast/nightfox.nvim' }, { confirm = false })

require('nightfox').setup({
  palettes = {
    dawnfox = require('colors.light'),
    nordfox = require('colors.dark'),
  },
  groups = { all = require('colors.theme') },
})

vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
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
