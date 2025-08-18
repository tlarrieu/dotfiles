local filename_first_and_shorten = {
  'filename_first',
  shorten = { len = 1, exclude = { 1, -3, -2, -1 } }
}

local find_files = { 'fd', '-tf', '--hidden' }
local find_directories = { 'fd', '-td' }

if require('helpers').fileexists('.ignore') then
  vim.list_extend(find_files, { '--no-ignore-vcs' })
  vim.list_extend(find_directories, { '--no-ignore-vcs' })
end

return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    { 'nvim-treesitter/nvim-treesitter' },
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release',
    },
  },
  keys = {
    { '<c-è>', '<cmd>Telescope resume<cr>', desc = 'Telescope resume' },
    {
      '<c-t>',
      function()
        return require('telescope.builtin').find_files({
          hidden = true,
          path_display = filename_first_and_shorten,
          find_command = find_files
        })
      end,
      desc = 'Telescope file finder'
    },
    {
      '<c-s-t>',
      function()
        require('oil') -- we need oil to “open” directories
        return require('telescope.builtin').find_files({
          hidden = true,
          path_display = filename_first_and_shorten,
          find_command = find_directories
        })
      end,
      desc = 'Telescope directories finder'
    },
    {
      '<c-b>',
      function()
        return require('telescope.builtin').buffers({
          hidden = true,
          path_display = filename_first_and_shorten
        })
      end,
      desc = 'Telescope buffers'
    },
    {
      '<c-h>',
      function() require('telescope.builtin').help_tags() end,
      desc = 'Telescope help tags'
    },
    {
      '<c-y>',
      function()
        return require('telescope.builtin').git_status({
          path_display = filename_first_and_shorten,
          git_icons = {
            added = "󰐕",
            changed = "~",
            copied = ">",
            deleted = "-",
            renamed = "",
            unmerged = "‡",
            untracked = "?",
          },
          attach_mappings = function(_, map)
            local actions = require('telescope.actions')
            map('i', '<tab>', actions.toggle_selection + actions.move_selection_next)
            map('i', '<c-s>', actions.git_staging_toggle)
            return true
          end,
        })
      end,
      desc = 'Telescope git status'
    },
    {
      '<c-s-b>',
      function() require('telescope.builtin').git_branches() end,
      desc = 'Telescope git branch'
    },
    {
      '<leader>gt',
      function() require('telescope.builtin').git_bcommits() end,
      desc = 'Telescope git commits'
    },
    {
      'gd',
      function() return require('telescope.builtin').lsp_definitions() end,
      desc = 'Telescope LSP definitions'
    },
    {
      '<c-w>gd',
      function() return require('telescope.builtin').lsp_definitions({ jump_type = 'vsplit' }) end,
      desc = 'Telescope LSP definitions (vertical split)'
    },
    {
      'gr',
      function() return require('telescope.builtin').lsp_references() end,
      desc = 'Telescope LSP references'
    },
    {
      '<c-w>gr',
      function() return require('telescope.builtin').lsp_references({ jump_type = 'vsplit' }) end,
      desc = 'Telescope LSP references (vertical split)'
    },
    {
      '<c-l>',
      function() require('telescope.builtin').lsp_document_symbols() end,
      desc = 'Telescope LSP document symbols'
    },
    {
      '<c-e>',
      function() require('telescope.builtin').diagnostics() end,
      desc = 'Telescope diagnostics'
    },
    {
      '<c-q>',
      function() require('telescope.builtin').quickfix() end,
      desc = 'Telescope quickfix'
    },
    {
      'g?',
      function() require('telescope.builtin').spell_suggest() end,
      desc = 'Telescope spell suggest'
    },
    {
      '<leader>eP',
      function()
        require('telescope.builtin').find_files({
          path_display = filename_first_and_shorten,
          cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
        })
      end,
      desc = 'Telescope plugins explorer'
    },
  },
  cmd = 'Telescope',
  config = function()
    local actions = require('telescope.actions')
    require('telescope').setup({
      defaults = {
        border = true,
        borderchars = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
        dynamic_preview_title = true,

        file_ignore_patterns = {
          '^%.git/',
          '%.png',
          '%.jpg'
        },

        prompt_prefix = '   ',
        selection_caret = ' ',
        entry_prefix = '⠀ ',
        multi_icon = ' ',

        path_display = { 'smart', 'shorten' },

        sorting_strategy = 'ascending',
        layout_config = {
          prompt_position = 'top',
          anchor = 'S',
          anchor_padding = 0,
          preview_width = 0.55,
          height = 0.75,
          width = 0.75,
        },

        mappings = {
          i = {
            ['<esc>'] = actions.close,
            ['<c-q>'] = actions.smart_send_to_qflist,
            ['<c-s-q>'] = actions.smart_add_to_qflist,
            ['<c-l>'] = actions.toggle_all,
            ['<tab>'] = actions.toggle_selection + actions.move_selection_next,
            ['<c-a>'] = { '<home>', type = 'command' },
            ['<c-e>'] = { '<end>', type = 'command' },
          },
        },
      },

      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown({
            prompt_prefix = '  ',
            layout_strategy = 'horizontal',
          }),
        },
        fzf = {
          fuzzy = false
        },
      }
    })

    require('telescope').load_extension('ui-select')
    require('telescope').load_extension('fzf')
  end
}
