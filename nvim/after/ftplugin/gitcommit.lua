local group = vim.api.nvim_create_augroup('GIT_AUTOCMD', {})

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = 'COMMIT_EDITMSG',
  callback = function()
    vim.cmd.startinsert()
    -- FIXME: since using neovim-git, startinsert! seems to be behaving weirdly
    -- (and cursor gets lost in the comments, and not at the end of the first
    -- line)
    vim.api.nvim_win_set_cursor(0, {1, 300})
    vim.keymap.set( { 'n', 'i' }, '<c-s>', vim.cmd.x, { silent = true, buffer = 0 })
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

require('utils').autocapitalize('COMMIT_EDITMSG')

vim.opt_local.spell = true
