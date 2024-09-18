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
  config = function()
    local actions = require('telescope.actions')

    require('telescope').setup({
      defaults = {
        border = true,
        results_title = false,
        file_ignore_patterns = { '^%.git/' },

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

    local builtin = require('telescope.builtin')
    local k = vim.keymap
    local options = { silent = true }
    local merge = require('helpers').merge

    k.set('n', '<c-t>', function()
      return builtin.find_files({
        hidden = true,
        path_display = { 'filename_first' }
      })
    end, merge(options, { desc = 'Telescope file finder' }))
    k.set('n', '<c-é>', function()
      return builtin.live_grep({ additional_args = { '--hidden' } })
    end, merge(options, { desc = 'Telescope live grep' }))
    k.set('n', '<leader>é', function()
      return builtin.grep_string({ additional_args = { '--hidden' } })
    end, merge(options, { desc = 'Telescope grep string' }))
    k.set('n', '<c-h>', builtin.help_tags, merge(options, { desc = 'Telescope help tags' }))
    k.set('n', '<c-y>', builtin.git_status, merge(options, { desc = 'Telescope git status' }))
    k.set('n', '<c-s-y>', builtin.git_branches, merge(options, { desc = 'Telescope git branch' }))
    k.set('n', '<c-l>', builtin.lsp_document_symbols, merge(options, { desc = 'Telescope LSP document symbols' }))
    k.set('n', '<c-e>', builtin.diagnostics, merge(options, { desc = 'Telescope diagnostics' }))
    k.set('n', '<c-q>', builtin.quickfix, merge(options, { desc = 'Telescope quickfix' }))
    k.set('n', 'g?', builtin.spell_suggest, merge(options, { desc = 'Telescope spell suggest' }))
    k.set('n', '<c-è>', ':TodoTelescope keywords=TODO,FIX,FIXME,WARN,PERF<cr>',
      merge(options, { desc = 'Telescope TODO' }))
  end
}
