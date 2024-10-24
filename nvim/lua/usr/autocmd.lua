vim.api.nvim_create_autocmd('SwapExists', {
  pattern = '*',
  callback = function() vim.v.swapchoice = 'e' end,
  group = vim.api.nvim_create_augroup('swapexists', {}),
})

-- Start with clean jumplist
vim.api.nvim_create_autocmd('VimEnter', {
  pattern = '*',
  callback = function() vim.cmd [[ clearjumps ]] end,
  group = vim.api.nvim_create_augroup('clearjumps', {})
})

-- Restore cursor position
vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = '*',
  callback = function() vim.api.nvim_exec2('keepjumps silent! normal! g`"zv', {}) end,
  group = vim.api.nvim_create_augroup('restore_position', {})
})

-- Balance splits size upon changing host window size
vim.api.nvim_create_autocmd('VimResized', {
  pattern = '*',
  callback = function() vim.api.nvim_input('<esc><c-w>=') end,
  group = vim.api.nvim_create_augroup('dimensions', {})
})

-- Do not insert comments upon <cr> or o/O
vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function() vim.opt_local.formatoptions:remove({ 'o', 'r' }) end,
  group = vim.api.nvim_create_augroup('no_incremental_comments', {})
})
