local filename_first_and_shorten = {
  'filename_first',
  shorten = { len = 1, exclude = { 1, -3, -2, -1 } }
}

return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release',
    },
  },
  keys = {
    {
      '<c-t>',
      function()
        return require('telescope.builtin').find_files({
          hidden = true,
          path_display = filename_first_and_shorten
        })
      end,
      { desc = 'Telescope file finder' }
    },
    {
      '<c-é>',
      function() return require('telescope.builtin').live_grep({ additional_args = { '--hidden' } }) end,
      { desc = 'Telescope live grep' }
    },
    {
      '<c-b>',
      function()
        return require('telescope.builtin').buffers({
          hidden = true,
          path_display = filename_first_and_shorten
        })
      end,
      { desc = 'Telescope buffers' }
    },
    {
      '<leader>é',
      function() return require('telescope.builtin').grep_string({ additional_args = { '--hidden' } }) end,
      { desc = 'Telescope grep string' }
    },
    {
      '<c-h>',
      function() require('telescope.builtin').help_tags() end,
      { desc = 'Telescope help tags' }
    },
    {
      '<c-y>',
      function()
        return require('telescope.builtin').git_status({
          hidden = true,
          path_display = filename_first_and_shorten
        })
      end,
      { desc = 'Telescope git status' }
    },
    {
      '<c-s-y>',
      function() require('telescope.builtin').git_branches() end,
      { desc = 'Telescope git branch' }
    },
    {
      '<c-l>',
      function() require('telescope.builtin').lsp_document_symbols() end,
      { desc = 'Telescope LSP document symbols' }
    },
    {
      '<c-e>',
      function() require('telescope.builtin').diagnostics() end,
      { desc = 'Telescope diagnostics' }
    },
    {
      '<c-q>',
      function() require('telescope.builtin').quickfix() end,
      { desc = 'Telescope quickfix' }
    },
    {
      'g?',
      function() require('telescope.builtin').spell_suggest() end,
      { desc = 'Telescope spell suggest' }
    },
    {
      '<c-è>',
      ':TodoTelescope keywords=TODO,FIX,FIXME,WARN,PERF<cr>',
      { desc = 'Telescope TODO' }
    },
  },
  cmd = 'Telescope',
  config = function()
    local actions = require('telescope.actions')

    require('telescope').setup({
      defaults = {
        border = true,
        results_title = false,
        file_ignore_patterns = {
          '^%.git/',
          '%.png',
          '%.jpg'
        },

        prompt_prefix = '  ',
        selection_caret = ' ',
        entry_prefix = '⠀ ',
        multi_icon = ' ',

        path_display = { 'smart', 'shorten' },

        sorting_strategy = 'ascending',
        layout_config = {
          prompt_position = 'top',
          preview_width = 0.7,
        },

        preview = {
          treesitter = {
            enable = true,
            disable = { 'html', 'eruby' },
          },
        },

        mappings = {
          i = {
            ['<esc>'] = actions.close,
            ['<c-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
            ['<c-l>'] = actions.toggle_all,
            ['<c-a>'] = { '<home>', type = 'command' },
            ['<c-e>'] = { '<end>', type = 'command' },
          },
        },
      },

      pickers = {
      },

      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown({
            prompt_prefix = '  ',
            layout_strategy = 'horizontal',
          }),
        },
      }
    })

    require('telescope').load_extension('ui-select')
    require('telescope').load_extension('fzf')
  end
}
