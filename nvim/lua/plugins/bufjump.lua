return {
  'kwkarlwang/bufjump.nvim',
  config = function()
    local bufjump = require('bufjump')
    bufjump.setup()
    vim.keymap.set("n", "<c-o>", bufjump.backward, { silent = true })
    vim.keymap.set("n", "<c-i>", bufjump.forward, { silent = true })
  end,
}
