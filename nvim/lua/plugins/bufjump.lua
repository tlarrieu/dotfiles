return {
  'kwkarlwang/bufjump.nvim',
  config = function()
    local bufjump = require('bufjump')
    bufjump.setup()
    vim.keymap.set('n', '<c-s-o>', bufjump.backward)
    vim.keymap.set('n', '<c-s-i>', bufjump.forward)
  end,
}
