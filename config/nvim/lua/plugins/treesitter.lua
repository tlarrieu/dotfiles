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
        'sql',
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

          local map = function(keys, kind, scope)
            local basepath

            if scope == 'local' then
              basepath = '~/git/dotfiles/config/nvim/after/queries/'
            elseif kind == 'textobjects' then
              basepath = '~/.local/share/nvim/lazy/nvim-treesitter-textobjects/queries/'
            else
              basepath = '~/.local/share/nvim/lazy/nvim-treesitter/runtime/queries/'
            end

            vim.keymap.set('n', keys,
              function() vim.cmd.vsplit(basepath .. vim.bo[ev.buf].filetype .. '/' .. kind .. '.scm') end,
              { desc = 'Edit ' .. kind .. ' queries (' .. scope .. ')', buffer = true })
          end

          map('<leader>eh', 'highlights', 'local')
          map('<leader>et', 'textobjects', 'local')
          map('<leader>eH', 'highlights', 'global')
          map('<leader>eT', 'textobjects', 'global')
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
  },
  {
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
}
