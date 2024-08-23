return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-telescope/telescope-ui-select.nvim' },
  },
  config = function()
    local actions = require('telescope.actions')

    require('telescope').setup({
      defaults = {
        border = true,
        file_ignore_patterns = { '^%.git/' },

        prompt_prefix = '  ',
        selection_caret = '󰄾 ',
        multi_icon = '󰆤 ',

        path_display = { 'smart', 'shorten' },

        sorting_strategy = 'ascending',
        layout_config = {
          prompt_position = 'top',
          preview_width = 0.7,
        },

        mappings = {
          i = {
            ['<esc>'] = actions.close,
            ['<c-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
            ['<c-l>'] = actions.toggle_all,
            ['<c-a>'] = { '<home>', type = 'command' },
            ['<c-e>'] = { '<end>', type = 'command' },
          },
        }
      },

      pickers = {
      },

      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown({
            prompt_prefix = '   ',
            layout_strategy = 'horizontal',
          }),
        }
      }
    })

    require('telescope').load_extension('ui-select')

    local builtin = require('telescope.builtin')
    local k = vim.keymap
    local options = { silent = true }

    k.set('n', '<c-t>', function() return builtin.find_files({ hidden = true }) end, options)
    k.set('n', '<c-é>', function() return builtin.live_grep({ additional_args = { '--hidden' } }) end, options)
    k.set('n', '<leader>é', function() return builtin.grep_string({ additional_args = { '--hidden' } }) end, options)
    k.set('n', '<c-h>', builtin.help_tags, options)
    k.set('n', '<c-y>', builtin.git_status, options)
    k.set('n', '<c-s-y>', builtin.git_branches, options)
    k.set('n', '<c-l>', builtin.lsp_document_symbols, options)
    k.set('n', '<c-e>', builtin.diagnostics, options)
    k.set('n', '<c-q>', builtin.quickfix, options)
    k.set('n', 'g?', builtin.spell_suggest, options)
    k.set('n', '<c-è>', ':TodoTelescope keywords=TODO,FIX,FIXME,WARN,PERF<cr>', options)
  end
}
