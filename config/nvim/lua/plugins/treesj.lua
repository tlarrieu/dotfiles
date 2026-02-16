return {
  'Wansmer/treesj',
  cmd = { 'TSJToggle', 'TSJSplit', 'TSJJoin', },
  keys = {
    {
      '<leader>,',
      function() require('treesj').toggle() end,
      desc = 'Toggle split'
    },
    {
      '<leader>;',
      function() require('treesj').toggle({ split = { recursive = true } }) end,
      desc = 'Toggle split (recursive)'
    },
    {
      '<c-cr>',
      function()
        require('treesj').split()
        vim.api.nvim_input('<esc>O')
      end,
      desc = 'Split',
      mode = { 'i' }
    },
  },
  opts = {
    max_join_length = 1000,
    use_default_keymaps = false,
  },
}
