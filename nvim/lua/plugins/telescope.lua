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

        prompt_prefix = '   ',
        selection_caret = ' ',
        multi_icon = ' ',

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

    -- Do not fire autocomplete
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'TelescopePrompt',
      command = "call deoplete#custom#buffer_option('auto_complete', v:false)",
    })
  end
}
