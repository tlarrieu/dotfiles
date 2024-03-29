local group = vim.api.nvim_create_augroup("luasnip_hooks", {})

local function insert_skel()
  vim.cmd.startinsert()
  vim.api.nvim_feedkeys("_skel", "insert", false)
  vim.api.nvim_input('<tab>')

  return true
end

local function try_insert()
  for _, item in pairs(require('luasnip').available()[vim.o.filetype]) do
    if item.name == "_skel" then
      return insert_skel()
    end
  end
  return false
end

vim.api.nvim_create_autocmd('BufNewFile', {
  pattern = '*',
  callback = try_insert,
  group = group
})
