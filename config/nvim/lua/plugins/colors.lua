return {
  'EdenEast/nightfox.nvim',
  lazy = false,
  opts = {
    options = {
      transparent = false,
      dim_inactive = false,
      styles = {
        strings = 'italic',
        comments = 'italic',
      },
    },
    palettes = require('plugins.colors.palettes'),
    groups = { all = require('plugins.colors.theme') },
  },
  config = function(_, opts)
    require('nightfox').setup(opts)

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
  end,
}
