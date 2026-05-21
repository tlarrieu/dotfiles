vim.pack.add({ 'https://github.com/austintaylor/vim-indentobject' }, { confirm = false })

-- we want the plugin to be loaded first, otherwise vim.keymap.del will raise an
-- error for keymaps not yet defined by the plugin
vim.schedule(function()
  vim.keymap.del('s', 'ai')
  vim.keymap.del('s', 'ii')
end)
