local group = vim.api.nvim_create_augroup('JS_AUTOCMD', {})

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = { '*.js' },
  callback = function()
    vim.keymap.set('n', '<cr>', ':T node %', { silent = true, buffer = true })
    vim.keymap.set('n', '<leader><cr>', ':TestLast | Topen<cr>', { silent = true, buffer = true })
  end,
  group = group
})

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = { '*.spec.js' },
  callback = function()
    vim.keymap.set('n', '<cr>', ':TestNearest | Topen<cr>', { silent = true, buffer = true })
    vim.keymap.set('n', '<leader><cr>', ':TestFile | Topen<cr>', { silent = true, buffer = true })
  end,
  group = group
})
