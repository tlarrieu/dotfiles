local o = vim.opt_local

o.conceallevel = 0
o.concealcursor = 'cni'
o.formatprg = 'prettier'

local group = vim.api.nvim_create_augroup('TS_AUTOCMD', {})

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = { '*.ts' },
  callback = function()
    vim.keymap.set('n', '<leader><cr>', ':TestFile | Topen<cr>', { silent = true, buffer = true })
  end,
  group = group
})

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = { '*.test.ts' },
  callback = function()
    vim.keymap.set('n', '<cr>', ':TestNearest | Topen<cr>', { silent = true, buffer = true })
    vim.keymap.set('n', '<leader><cr>', ':TestFile | Topen<cr>', { silent = true, buffer = true })
  end,
  group = group
})
