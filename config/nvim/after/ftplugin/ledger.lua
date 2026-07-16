vim.opt_local.commentstring = '; %s'
vim.opt_local.iskeyword:append({ ':', '/', '.' })

vim.b.to_treesitter_options = true

local runner = require('runner')

local ftnow = { cmd = { 'fish', '-c', 'ft now' }, winbar = '󰗑 ft now', show = true }

local ft = function(cmd)
  return {
    cmd = { 'fish', '-c', ('ft %s'):format(cmd) },
    winbar = ('󰗑 ft %s'):format(cmd),
    show = true,
  }
end

runner.setup({
  main = { args = ft('now'), desc = 'ft now' },
  alt = { args = ft('up'), desc = 'ft up' },
})

vim.api.nvim_create_autocmd('BufWritePre', { buffer = 0, callback = function() runner.run(ft('now')) end })
