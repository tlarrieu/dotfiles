return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    { 'nvim-lua/plenary.nvim' }
  },
  config = function()
    local actions = require('telescope.actions')
    local actions_layout = require('telescope.actions.layout')

    require('telescope').setup {
      defaults = {
        border = true,

        prompt_prefix = '   ',
        selection_caret = '󰄾 ',
        multi_icon = '󰆤 ',

        path_display = { 'smart', 'shorten' },

        sorting_strategy = 'ascending',
        layout_config = {
          prompt_position = 'top',
          preview_width = 0.55,
        },

        mappings = {
          i = {
            ['<esc>'] = actions.close,
            ['<c-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
            ['<c-l>'] = actions_layout.toggle_preview,
            ['<c-a>'] = { '<home>', type = 'command' },
            ['<c-e>'] = { '<end>', type = 'command' },
          },
        }
      },

      pickers = {
      },

      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = 'smart_case',
        }
      }
    }

    require('telescope').load_extension('fzf')

    local builtin = require('telescope.builtin')
    local k = vim.keymap
    local options = { silent = true }

    k.set('n', '<c-t>', builtin.find_files, options)
    k.set('n', '<c-é>', builtin.live_grep, options)
    k.set('n', '<leader>é', builtin.grep_string, options)
    k.set('n', '<c-h>', builtin.help_tags, options)
    k.set('n', '<c-y>', builtin.git_status, options)
    k.set('n', '<c-l>', builtin.lsp_document_symbols, options)
    k.set('n', '<c-e>', builtin.diagnostics, options)
    k.set('n', '<c-q>', builtin.quickfix, options)
    k.set('n', 'g?', builtin.spell_suggest, options)
    k.set('n', '<c-è>', ':TodoTelescope keywords=TODO,FIX,WARN,PERF<cr>', options)
  end
}
