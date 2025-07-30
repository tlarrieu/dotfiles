vim.keymap.set('n', '<c-l>', ':YAMLTelescope<cr>', { desc = 'Telescope YAML', silent = true, buffer = true })

vim.keymap.set('n', '<c-$>', function()
  require('alternator').alternate({
    ["(.*)/(.*%.?)en%.yml"] = "%1/%2fr.yml",
    ["(.*)/(.*%.?)fr%.yml"] = "%1/%2en.yml",

    ["(.*)/(.*%.?)2025%.yml"] = "%1/%22024.yml",
    ["(.*)/(.*%.?)2024%.yml"] = "%1/%22025.yml",
  })
end, { silent = true, buffer = true })

vim.keymap.set('n', '<leader>yk', ':YAMLYankKey<cr>', { silent = true, buffer = true })
vim.keymap.set('n', '<leader>yv', ':YAMLYankValue<cr>', { silent = true, buffer = true })
