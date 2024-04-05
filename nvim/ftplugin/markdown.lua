local o = vim.opt_local

o.textwidth = 130
o.formatoptions = o.formatoptions + 't'
o.foldlevel = 1
o.foldlevelstart = 10
o.spell = true
o.concealcursor = 'ncv'
o.conceallevel = 2

vim.keymap.set('n', '<leader>i', function()
  if vim.opt.conceallevel:get() == 2 then
    o.conceallevel = 0
  else
    o.conceallevel = 2
  end
end, { silent = true, buffer = true })

local runner = require('runner')
runner.default({ main = runner.term("mdprev w '%'") })

vim.keymap.set('v', '<leader>b', 'S*gvS*eee', { buffer = true, remap = true })
vim.keymap.set('v', '<leader>i', 'S_ee', { buffer = true, remap = true })
vim.keymap.set('v', '<leader>s', 'S~gvS~eee', { buffer = true, remap = true })

require('utils').autocapitalize('*.md')

local group = vim.api.nvim_create_augroup('MARKDOWN_AUTOCMD', {})

vim.api.nvim_create_autocmd('InsertLeave', {
  pattern = { '*' },
  callback = function() o.conceallevel = 2 end,
  group = group
})
