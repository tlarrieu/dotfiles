vim.pack.add({ 'https://github.com/edeneast/nightfox.nvim' }, { confirm = false })

local Color = require('nightfox.lib.color')

local paint = function(color, palette)
  local bg = Color.from_hex(palette.bg.base)
  local base = Color.from_hex(palette[color])

  return {
    base = base:to_css(),
    dim = bg:blend(base, 0.2):to_css(),
    dimmer = bg:blend(base, 0.15):to_css(),
  }
end

local palettes = require('colors.palettes')
for _, flavor in ipairs({ 'light', 'dark' }) do
  for _, name in ipairs({
    'black',
    'blue',
    'cyan',
    'green',
    'magenta',
    'orange',
    'pink',
    'red',
    'white',
    'yellow',
  }) do
    palettes[flavor][name] = paint(name, palettes[flavor])
  end

  palettes[flavor].fg0 = palettes[flavor].fg.dim
  palettes[flavor].fg1 = palettes[flavor].fg.base
  palettes[flavor].fg2 = palettes[flavor].fg.dim
  palettes[flavor].fg3 = palettes[flavor].fg.dimmer

  palettes[flavor].bg0 = palettes[flavor].bg.dark
  palettes[flavor].bg1 = palettes[flavor].bg.base
  palettes[flavor].bg2 = palettes[flavor].bg.dim
  palettes[flavor].bg3 = palettes[flavor].bg.dimmer
  palettes[flavor].bg4 = palettes[flavor].bg.border

  palettes[flavor].sel0 = palettes[flavor].sel.base
  palettes[flavor].sel1 = palettes[flavor].sel.dim

  palettes[flavor].comment = palettes[flavor].fg.dimmer
end

require('nightfox').setup({
  palettes = { dawnfox = palettes.light, nordfox = palettes.dark },
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
