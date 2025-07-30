vim.keymap.set('n', '<c-l>', ':YAMLTelescope<cr>', { desc = 'Telescope YAML', silent = true, buffer = true })

vim.keymap.set('n', '<c-$>', function()
  require('alternator').alternate({
    ["(.*)/(.*%.?)en%.yml"] = "%1/%2fr.yml",
    ["(.*)/(.*%.?)fr%.yml"] = "%1/%2en.yml",
  })
end, { silent = true, buffer = true })

vim.keymap.set('n', '<leader>yk', ':YAMLYankKey<cr>', { silent = true, buffer = true })
vim.keymap.set('n', '<leader>yv', ':YAMLYankValue<cr>', { silent = true, buffer = true })
