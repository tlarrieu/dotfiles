vim.opt_local.commentstring = '; %s'
vim.opt_local.iskeyword:append({ ':', '/', '.' })

local runner = require('runner')

local ftnow = { cmd = { 'fish', '-c', 'ft now', }, winbar = '󰗑 ft now', show = true }

runner.setup({
  main = { args = ftnow, desc = 'ft now' },
  alt = { args = { cmd = { 'fish', '-c', 'ft up' }, winbar = '󰗑 ft up', show = true }, desc = 'ft up' },
})

vim.api.nvim_create_autocmd('BufWritePre', { buffer = 0, callback = function() runner.run(ftnow) end })
