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

-- Deactivate spell checking on RO files
vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = '*',
  callback = function() if vim.bo.readonly then vim.opt_local.spell = false end end,
  group = vim.api.nvim_create_augroup('restore_position', {})
})

-- Set relativenumber only in active window
local group = vim.api.nvim_create_augroup('autonumber_group', {})

vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter' }, {
  pattern = { '*' },
  callback = function() if vim.wo.number then vim.wo.relativenumber = true end end,
  group = group
})

vim.api.nvim_create_autocmd('WinLeave', {
  pattern = { '*' },
  callback = function() vim.wo.relativenumber = false end,
  group = group
})

-- auto turn on relativenumber if we activate number
vim.api.nvim_create_autocmd('OptionSet', {
  pattern = { 'number' },
  callback = function() vim.wo.relativenumber = vim.wo.number end,
  group = group
})
