local group = vim.api.nvim_create_augroup('GIT_AUTOCMD', {})

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = 'COMMIT_EDITMSG',
  callback = function()
    -- enter insert mode
    vim.cmd('startinsert!')
    -- <c-s> saves and exits
    vim.keymap.set( { 'n', 'i' }, '<c-s>', vim.cmd.x, { silent = true, buffer = 0 })
  end,
  group = group
})

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = 'COMMIT_EDITMSG',
  callback = require('noice').disable,
  group = group
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'FugitiveChanged',
  callback = require('noice').enable,
  group = group
})

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = 'index',
  callback = function()
    vim.keymap.set('n', '<c-s>', '<cmd>Gitcommit<cr>', { silent = true, buffer = 0 })
    vim.keymap.set('n', '<c-a>', '<cmd>Gitcommit --amend<cr>', { silent = true, buffer = 0 })
  end,
  group = group
})

vim.api.nvim_create_autocmd('InsertCharPre', {
  pattern = 'COMMIT_EDITMSG',
  command = "call helpers#Capitalize()",
  group = group
})

vim.opt_local.spell = true

vim.fn["bullet#config"]()
