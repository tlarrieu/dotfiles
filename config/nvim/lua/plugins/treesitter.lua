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
      })

      vim.api.nvim_create_autocmd('FileType', {
        callback = function()
          local ok, _ = pcall(vim.treesitter.start)
          if ok then vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
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
