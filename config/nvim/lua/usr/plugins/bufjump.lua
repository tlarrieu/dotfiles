vim.pack.add({ 'https://github.com/kwkarlwang/bufjump.nvim' }, { confirm = false })

require('bufjump').setup({
  backward_key = '<c-s-o>',
  forward_key  = '<c-s-i>',
  on_success   = function() vim.cmd.normal('zz') end
})
