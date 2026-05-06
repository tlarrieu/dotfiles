vim.opt_local.commentstring = '; %s'
vim.opt_local.iskeyword:append({ ':', '/', '.' })
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.shiftround = true
vim.opt_local.autoindent = false
vim.opt_local.smartindent = false

require('runner').setup({
  main = { args = { cmd = { 'fish', '-c', 'ft now', }, winbar = '󰗑 ft now' }, desc = 'ft now' },
  alt = { args = { cmd = { 'fish', '-c', 'ft up' }, winbar = '󰗑 ft up' }, desc = 'ft up' },
})
