vim.pack.add({ 'https://github.com/EdenEast/nightfox.nvim' }, { confirm = false })

require('nightfox').setup({
  options = {
    transparent = false,
    dim_inactive = false,
    styles = {
      strings = 'italic',
      comments = 'italic',
    },
  },
  palettes = require('colors.palettes'),
  groups = { all = require('colors.theme') },
})

vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function(args)
    local ok, palette = pcall(require, 'nightfox.palette')
    if not ok then return end

    palette = palette.load(args.match)
    if not palette then return end

    local devicons
    ok, devicons = pcall(require, 'nvim-web-devicons')
    if not ok then return end
    if not palette.fg then return end
    devicons.set_default_icon('', palette.fg.dim, 0)
  end,
  group = vim.api.nvim_create_augroup('nightfox_group', {})
})
