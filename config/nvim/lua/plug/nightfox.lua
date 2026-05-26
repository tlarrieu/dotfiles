vim.pack.add({ 'https://github.com/edeneast/nightfox.nvim' }, { confirm = false })

local colors = require('colors')

local setup = function()
  local palettes = {
    dawnfox = colors.palettes.light,
    nordfox = colors.palettes.dark,
  }

  palettes.dawnfox.fg0 = colors.palettes.light.fg.dim
  palettes.dawnfox.fg1 = colors.palettes.light.fg.base
  palettes.dawnfox.fg2 = colors.palettes.light.fg.dim
  palettes.dawnfox.fg3 = colors.palettes.light.fg.dimmer

  palettes.dawnfox.bg0 = colors.palettes.light.bg.dark
  palettes.dawnfox.bg1 = colors.palettes.light.bg.base
  palettes.dawnfox.bg2 = colors.palettes.light.bg.dim
  palettes.dawnfox.bg3 = colors.palettes.light.bg.dimmer
  palettes.dawnfox.bg4 = colors.palettes.light.bg.border

  palettes.dawnfox.sel0 = colors.palettes.light.sel.base
  palettes.dawnfox.sel1 = colors.palettes.light.sel.dim

  palettes.nordfox.fg0 = colors.palettes.dark.fg.dim
  palettes.nordfox.fg1 = colors.palettes.dark.fg.base
  palettes.nordfox.fg2 = colors.palettes.dark.fg.dim
  palettes.nordfox.fg3 = colors.palettes.dark.fg.dimmer

  palettes.nordfox.bg0 = colors.palettes.dark.bg.dark
  palettes.nordfox.bg1 = colors.palettes.dark.bg.base
  palettes.nordfox.bg2 = colors.palettes.dark.bg.dim
  palettes.nordfox.bg3 = colors.palettes.dark.bg.dimmer
  palettes.nordfox.bg4 = colors.palettes.dark.bg.border

  palettes.nordfox.sel0 = colors.palettes.dark.sel.base
  palettes.nordfox.sel1 = colors.palettes.dark.sel.dim

  require('nightfox').setup({
    palettes = palettes,
    groups = { all = colors.theme },
  })
end

vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    setup()
    local palette = colors.palette()
    if not palette then return end

    local ok, devicons = pcall(require, 'nvim-web-devicons')
    if not ok then return end

    devicons.set_default_icon('', palette.fg.dim, 0)
  end,
})

setup()
