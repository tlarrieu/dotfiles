return {
  'kwkarlwang/bufjump.nvim',
  config = function()
    local bufjump = require('bufjump')
    bufjump.setup()
    vim.keymap.set('n', '<c-o>', bufjump.backward)
    vim.keymap.set('n', '<c-i>', bufjump.forward)
  end,
}
