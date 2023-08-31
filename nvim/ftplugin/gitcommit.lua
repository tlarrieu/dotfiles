local group = vim.api.nvim_create_augroup('GIT_AUTOCMD', {})

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = 'COMMIT_EDITMSG',
  callback = function()
    -- move to end of first line
    vim.api.nvim_win_set_cursor(0, { 1, 1000000 })
    -- enter insert mode
    vim.cmd('startinsert!')
    -- <c-s> saves and exits
    vim.keymap.set({ 'n', 'i' }, '<c-s>', '<esc><cmd>x<cr>', { silent = true, buffer = 0 })
  end,
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
