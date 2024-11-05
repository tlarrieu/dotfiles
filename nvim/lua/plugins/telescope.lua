local filename_first_and_shorten = {
  'filename_first',
  shorten = { len = 1, exclude = { 1, -3, -2, -1 } }
}

local find_files = { 'fd', '-tf', '--hidden' }
local find_directories = { 'fd', '-td' }

local file = io.open('.ignore', 'r')
if file then
  for _, tab in ipairs({ find_files, find_directories }) do
    vim.list_extend(tab, { '--no-ignore-vcs' })
  end

  file:close()
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
      desc = 'Telescope file finder'
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
          hidden = true,
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
        })
      end,
      desc = 'Telescope git status'
    },
    {
      '<c-s-y>',
      function() require('telescope.builtin').git_branches() end,
      desc = 'Telescope git branch'
    },
    {
      'go',
      function() return require('telescope.builtin').lsp_type_definitions() end,
      desc = 'Telescope LSP type references'
    },
    {
      'gd',
      function() return require('telescope.builtin').lsp_definitions() end,
      desc = 'Telescope LSP references'
    },
    {
      'gr',
      function() return require('telescope.builtin').lsp_references() end,
      desc = 'Telescope LSP references'
    },
    {
      '<c-l>',
      function() require('telescope.builtin').lsp_dynamic_workspace_symbols() end,
      desc = 'Telescope LSP workspace symbols'
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
  },
  cmd = 'Telescope',
  config = function()
    local actions = require('telescope.actions')

    require('telescope').setup({
      defaults = {
        border = true,
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
        },

        mappings = {
          i = {
            ['<esc>'] = actions.close,
            ['<c-q>'] = actions.smart_send_to_qflist,
            ['<c-l>'] = actions.toggle_all,
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
