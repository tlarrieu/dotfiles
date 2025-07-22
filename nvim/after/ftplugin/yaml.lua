vim.keymap.set('n', '<c-l>', ':YAMLTelescope<cr>', { desc = 'Telescope YAML', silent = true, buffer = true })

local alternate = function()
  local path = vim.api.nvim_buf_get_name(0)
  local alt
  if path:match('en%.yml$') then
    alt = path:gsub("(.*)/(.*%.?)en%.yml", "%1/%2fr.yml")
  else
    alt = path:gsub("(.*)/(.*%.?)fr%.yml", "%1/%2en.yml")
  end
  vim.cmd.edit(alt)
end

vim.keymap.set('n', '<c-$>', alternate, { silent = true, buffer = true })
vim.keymap.set('n', '<leader>yk', ':YAMLYankKey<cr>', { silent = true, buffer = true })
vim.keymap.set('n', '<leader>yv', ':YAMLYankValue<cr>', { silent = true, buffer = true })
