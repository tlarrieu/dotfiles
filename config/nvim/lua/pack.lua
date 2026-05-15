local purge = function()
  local unused = vim.iter(vim.pack.get())
      :filter(function(x) return not x.active end)
      :map(function(x) return x.spec.name end)
      :totable()

  vim.pack.del(unused)
end

local update = function() vim.pack.update() end
local list = function() vim.pack.update(nil, { offline = true }) end

vim.api.nvim_create_user_command('PackPurge', purge, {})
vim.api.nvim_create_user_command('PackList', list, {})
vim.api.nvim_create_user_command('PackUpdate', update, {})
