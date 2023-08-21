vim.api.nvim_create_autocmd('SwapExists', {
    pattern = '*',
    callback = function()
      vim.v.swapchoice = 'o'
      print('Duplicate session (readonly)')
      vim.cmd [[ sleep 1 ]]
    end,
    group = vim.api.nvim_create_augroup("no_simultaneous_edits", {}),
  })

-- Restore cursor position
vim.api.nvim_create_autocmd('BufReadPost', {
    pattern = '*',
    callback = function() vim.api.nvim_exec('silent! normal! g`"zv', false) end,
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
    callback = function() vim.opt_local.formatoptions:remove({'o', 'r'}) end,
    group = vim.api.nvim_create_augroup('no_incremental_comments', {})
  })
