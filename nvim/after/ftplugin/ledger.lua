vim.opt_local.commentstring = '; %s'
vim.opt_local.iskeyword:append({ ':', '/', '.' })
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.shiftround = true
vim.opt_local.autoindent = false
vim.opt_local.smartindent = false

vim.keymap.set('n', '<c-cr>', 'o<c-u>', { remap = true, buffer = true })
vim.keymap.set('i', '<c-cr>', '<cr><c-u>', { remap = true, buffer = true })

local runner = require('runner')

runner.default({
  main = runner.term('ft now', { open = true, direction = 'float' }),
  alt = runner.term('ft up', { open = true, direction = 'float' }),
})

vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = { '*.journal' },
  callback = function()
    require('utils').trim_trailing_spaces()
    runner.term('ft sum', { open = true, direction = 'vertical' })()
  end,
  group = vim.api.nvim_create_augroup('ledger_after_save', {})
})
