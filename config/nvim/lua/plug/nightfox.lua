vim.pack.add({ 'https://github.com/edeneast/nightfox.nvim' }, { confirm = false })

local colors = require('colors')

local palettes = colors.palettes()

require('nightfox').setup({
  palettes = { dawnfox = palettes.light, nordfox = palettes.dark },
  groups = { all = colors.theme },
})

vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    local palette = colors.palette()
    if not palette then return end

    local ok, devicons = pcall(require, 'nvim-web-devicons')
    if not ok then return end

    devicons.set_default_icon('', palette.fg.dim, 0)
  end,
})
