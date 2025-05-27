local o = vim.opt_local
o.commentstring = '; %s'
o.iskeyword = o.iskeyword + ':' + '/' + '.'
o.expandtab = true
o.tabstop = 2
o.shiftwidth = 2
o.shiftround = true

vim.keymap.set('n', '<c-cr>', 'o<c-u>', { remap = true, buffer = true })

local runner = require('runner')
runner.default({
  main = runner.term('fish -c "ft now"'),
  alt = runner.term('fish -c "ft up"'),
})

local group = vim.api.nvim_create_augroup('ledger_after_save', {})

vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = { '*.journal' },
  callback = require('utils').trim_trailing_spaces,
  group = group
})

vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = { '*.journal' },
  callback = function() vim.cmd(runner.term('fish -c "ft now"')) end,
  group = group
})
