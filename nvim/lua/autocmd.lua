vim.api.nvim_create_autocmd('SwapExists', {
  pattern = '*',
  callback = function()
    vim.v.swapchoice = 'o'
    print('Duplicate session (readonly)')
    vim.cmd [[ sleep 1 ]]
  end,
  group = vim.api.nvim_create_augroup("no_simultaneous_edits", {}),
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
  callback = function() vim.api.nvim_exec('keepjumps silent! normal! g`"zv', false) end,
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

-- Update location list with diagnostics
vim.api.nvim_create_autocmd('DiagnosticChanged', {
  pattern = '*',
  callback = function() vim.diagnostic.setloclist({ winnr = 0, open = false }) end,
  group = vim.api.nvim_create_augroup('diagnostics_to_loclist', {})
})
