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
vim.api.nvim_create_user_command('PackDel', function(opts) del(opts.args) end, { nargs = 1, desc = 'Delete a pack' })

-- Command line shorthand
local abbr = {
  chmod = 'Chmod',
  mkdir = 'Mkdir',
  mv = 'Rename',
  rm = 'Delete',
  ['rm!'] = 'Delete!',
  git = 'Git',
  h = 'tab h',
  hi = "lua require('telescope.builtin').highlights()",
  map = "lua require('telescope.builtin').keymaps({lfs_filter = true })",
  mason = 'Mason',
  fid = 'Fidget',
  ins = 'Inspect',
  ts = 'InspectTree',
  man = 'tab Man',
  ls = 'PackUpdate',
  pp = 'PackPurge',
  dd = 'CodeDiff',
}

for key, value in pairs(abbr) do
  vim.cmd.cnoreabbrev(
    '<expr>',
    key,
    [[getcmdtype() == ":" && getcmdline() == ']] .. key .. [[' ? "]] .. value .. [[" : ']] .. key .. [[']]
  )
end
