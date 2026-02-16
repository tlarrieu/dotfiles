return {
  'kwkarlwang/bufjump.nvim',
  opts = {
    backward_key = '<c-s-o>',
    forward_key  = '<c-s-i>',
    on_success   = function() vim.cmd.normal('zz') end -- for some reason this does trigger oO
  },
}
