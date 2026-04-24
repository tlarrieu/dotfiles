return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    branch = 'main',
    config = function()
      local treesitter = require('nvim-treesitter')
      treesitter.setup()
      treesitter.install({
        'bash',
        'fish',
        'gitcommit',
        'go',
        'gomod',
        'haskell',
        'javascript',
        'just',
        'lua',
        'luadoc',
        'markdown',
        'ocaml',
        'query',
        'ruby',
        'yaml',
        'json',
        'tsx',
        'typescript',
        'ledger',
        'vim',
        'vimdoc',
        'xresources',
      })

      vim.api.nvim_create_autocmd('FileType', {
        callback = function(ev)
          local ok, _ = pcall(vim.treesitter.start)

          if not ok then return end

          vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          vim.wo.foldmethod = 'expr'
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

          local ft = vim.bo[ev.buf].filetype
          local lazypath = '~/.local/share/nvim/lazy'
          local localpath = '~/git/dotfiles/config/nvim'

          vim.keymap.set('n', '<leader>eh',
            function() vim.cmd.vsplit(localpath .. '/after/queries/' .. ft .. '/highlights.scm') end,
            { desc = 'Edit highlight queries (local)', buffer = true })
          vim.keymap.set('n', '<leader>et',
            function() vim.cmd.vsplit(localpath .. '/after/queries/' .. ft .. '/textobjects.scm') end,
            { desc = 'Edit textobject queries (local)', buffer = true })

          vim.keymap.set('n', '<leader>eH',
            function() vim.cmd.vsplit(lazypath .. '/nvim-treesitter/runtime/queries/' .. ft .. '/highlights.scm') end,
            { desc = 'Edit highlight queries (global)', buffer = true })
          vim.keymap.set('n', '<leader>eT',
            function() vim.cmd.vsplit(lazypath .. '/nvim-treesitter-textobjects/queries/' .. ft .. '/textobjects.scm') end,
            { desc = 'Edit textobjcets queries (global)', buffer = true })
        end,
      })
    end
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    branch = 'main',
    main = 'nvim-treesitter',
    opts = {
      select = {
        lookahead = true,

        selection_modes = {
          ['@block.outer'] = 'V',
        },
      },
    },
    config = function(_, opts)
      require('nvim-treesitter-textobjects').setup(opts)

      local select = require 'nvim-treesitter-textobjects.select'

      vim.keymap.set({ 'x', 'o' }, 'if', function() select.select_textobject('@function.inner', 'textobjects') end)
      vim.keymap.set({ 'x', 'o' }, 'af', function() select.select_textobject('@function.outer', 'textobjects') end)
      vim.keymap.set({ 'x', 'o' }, 'ia', function() select.select_textobject('@parameter.inner', 'textobjects') end)
      vim.keymap.set({ 'x', 'o' }, 'aa', function() select.select_textobject('@parameter.outer', 'textobjects') end)
      vim.keymap.set({ 'x', 'o' }, 'ie', function() select.select_textobject('@block.inner', 'textobjects') end)
      vim.keymap.set({ 'x', 'o' }, 'ae', function() select.select_textobject('@block.outer', 'textobjects') end)
      vim.keymap.set({ 'x', 'o' }, 'ic', function() select.select_textobject('@conditional.inner', 'textobjects') end)
      vim.keymap.set({ 'x', 'o' }, 'ac', function() select.select_textobject('@conditional.outer', 'textobjects') end)
      vim.keymap.set({ 'x', 'o' }, 'iC', function() select.select_textobject('@class.inner', 'textobjects') end)
      vim.keymap.set({ 'x', 'o' }, 'aC', function() select.select_textobject('@class.outer', 'textobjects') end)
      vim.keymap.set({ 'x', 'o' }, 'il', function() select.select_textobject('@assignment.lhs', 'textobjects') end)
      vim.keymap.set({ 'x', 'o' }, 'ir', function() select.select_textobject('@assignment.rhs', 'textobjects') end)
    end
  }
}
