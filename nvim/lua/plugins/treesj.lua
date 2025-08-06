return {
  'Wansmer/treesj',
  cmd = { 'TSJToggle', 'TSJSplit', 'TSJJoin', },
  keys = {
    {
      '<leader>,',
      function() require('treesj').toggle() end,
      silent = true,
      desc = 'Toggle split'
    },
    {
      '<leader>;',
      function() require('treesj').toggle({ split = { recursive = true } }) end,
      silent = true,
      desc = 'Toggle split (recursive)'
    },
  },
  opts = {
    max_join_length = 1000,
    use_default_keymaps = false,
  },
}
