local group = vim.api.nvim_create_augroup('autonumber_group', {})

vim.api.nvim_create_autocmd('WinEnter', {
  pattern = { '*' },
  callback = function()
    if vim.wo.number then
      vim.wo.relativenumber = true
    end
  end,
  group = group
})

vim.api.nvim_create_autocmd('WinLeave', {
  pattern = { '*' },
  callback = function()
    vim.wo.relativenumber = false
  end,
  group = group
})

-- auto turn on relativenumber if we activate number
vim.api.nvim_create_autocmd('OptionSet', {
  pattern = { 'number' },
  callback = function()
    vim.wo.relativenumber = vim.wo.number
  end,
  group = group
})
