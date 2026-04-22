return {
  {
    'nvim-treesitter/nvim-treesitter',
    version = '*',
    build = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
    end,
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = {
        'bash',
        'fish',
        'gitcommit',
        'go',
        'gomod',
        'haskell',
        'javascript',
        'lua',
        'luadoc',
        'markdown',
        'norg',
        'ocaml',
        'query',
        'ruby',
        'tsx',
        'typescript',
        'ledger',
        'vim',
        'vimdoc',
      },
      sync_install = false,
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true, disable = { 'ledger' } },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    main = 'nvim-treesitter.configs',
    opts = {
      textobjects = {
        enable = true,

        select = {
          enable = true,
          lookahead = true,

          keymaps = {
            ['if'] = '@function.inner',
            ['af'] = '@function.outer',
            ['ia'] = '@parameter.inner',
            ['aa'] = '@parameter.outer',
            ['ie'] = '@block.inner',
            ['ae'] = '@block.outer',
            ['ic'] = '@conditional.inner',
            ['ac'] = '@conditional.outer',
            ['iC'] = '@class.inner',
            ['aC'] = '@class.outer',
            ['il'] = '@assignment.lhs',
            ['ir'] = '@assignment.rhs',
          },

          selection_modes = {
            ['@block.outer'] = 'V',
          },
        },
      },
    },
  },
  config = function(_, opts)
    require('nvim-treesitter.configs').setup(opts)

    vim.keymap.set('n', '<leader>i', vim.show_pos, { desc = 'Inspect' })
    vim.keymap.set('n', '<leader>I', function() vim.treesitter.inspect_tree({ command = 'vnew' }) end,
      { desc = 'InspectTree' })

    vim.keymap.set('n', '<c-s-space>', 'van', { desc = 'Select current TS node', remap = true })
    vim.keymap.set('x', '<c-s-space>', 'an', { desc = 'Select parent TS node', remap = true })
    vim.keymap.set('x', '<bs>', 'in', { desc = 'Select child TS node', remap = true })
  end,
}
