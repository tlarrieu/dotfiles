local purge = function()
  local unused = vim.iter(vim.pack.get())
      :filter(function(x) return not x.active end)
      :map(function(x) return x.spec.name end)
      :totable()

  vim.pack.del(unused)
end

local update = function() vim.pack.update() end
local del = function(pack) vim.pack.del({ pack }) end

vim.api.nvim_create_user_command('PackPurge', purge, { desc = 'Purge all unused packs' })
vim.api.nvim_create_user_command('PackUpdate', update, { desc = 'Update all packs' })
vim.api.nvim_create_user_command('PackDel', function(opts) del(opts.args) end,
  { nargs = '?', desc = 'Delete a pack by name' })
