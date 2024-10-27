local o = vim.opt_local
o.commentstring = '; %s'
o.iskeyword = o.iskeyword + ':' + '/'
o.expandtab = true
o.tabstop = 2
o.shiftwidth = 2
o.shiftround = true

vim.keymap.set('n', '<c-cr>', 'o<c-u>', { remap = true, buffer = true })

local runner = require('runner')
runner.default({
  main = runner.term('ft now'),
  alt = runner.term('ft up'),
})

vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = { '*.journal' },
  callback = function() vim.cmd(runner.term('ft now')) end,
  group = vim.api.nvim_create_augroup('ledger_after_save', {})
})
