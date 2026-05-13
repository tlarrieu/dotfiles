vim.pack.add({
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/nvim-telescope/telescope-ui-select.nvim',
  { src = 'https://github.com/nvim-telescope/telescope-fzf-native.nvim', data = { build = 'make' } },
}, { confirm = false })

local filename_first_and_shorten = { 'filename_first', shorten = { len = 1, exclude = { 1, -3, -2, -1 } } }
local find_files = { 'fd', '-tf', '--hidden' }
local find_directories = { 'fd', '-td' }

if require('helpers').fileexists('.ignore') then
  vim.list_extend(find_files, { '--no-ignore-vcs' })
  vim.list_extend(find_directories, { '--no-ignore-vcs' })
end

local telescope = require('telescope')
local actions = require('telescope.actions')

telescope.setup({
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
    selection_caret = ' 󰫈 ',
    entry_prefix = ' 󰋙 ',
    multi_icon = ' 󰁘 ',

    path_display = { 'smart', 'shorten' },

    sorting_strategy = 'ascending',
    layout_config = {
      prompt_position = 'top',
      anchor = 'S',
      anchor_padding = 0,
      preview_width = 0.7,
      height = 30,
      width = 184,
    },

    preview = {
      treesitter = {
        enable = true,
        disable = { 'make' },
      }
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
        prompt_prefix = ' 󱐁 ',
        layout_strategy = 'horizontal',
      }),
    },
    fzf = { fuzzy = false },
  }
})

vim.keymap.set('n', '<c-è>', '<cmd>Telescope resume<cr>', { desc = 'Telescope resume' })
vim.keymap.set('n', '<c-t>', function()
  return require('telescope.builtin').find_files({
    hidden = true,
    path_display = filename_first_and_shorten,
    find_command = find_files,
    results_title = '󰈔 files',
  })
end, { desc = 'Telescope file finder' })

vim.keymap.set('n',
  '<c-s-t>',
  function()
    require('oil') -- we need oil to “open” directories
    return require('telescope.builtin').find_files({
      hidden = true,
      path_display = filename_first_and_shorten,
      find_command = find_directories,
      results_title = '󰉋 directories',
    })
  end,
  { desc = 'Telescope directories finder' }
)

vim.keymap.set('n',
  '<c-b>',
  function()
    return require('telescope.builtin').buffers({
      hidden = true,
      ignore_current_buffer = true,
      path_display = filename_first_and_shorten,
      sort_mru = true,
      results_title = ' buffers',
    })
  end,
  { desc = 'Telescope buffers' }
)

vim.keymap.set('n', '<c-l>',
  function() return require('telescope.builtin').registers({ results_title = ' registers' }) end,
  { desc = 'Telescope registers' }
)

vim.keymap.set('n', '<c-h>',
  function() require('telescope.builtin').help_tags({ results_title = ' documentation' }) end,
  { desc = 'Telescope help tags' }
)
vim.keymap.set('n', '<c-s-s>',
  function()
    return require('telescope.builtin').find_files({
      hidden = true,
      path_display = filename_first_and_shorten,
      find_command = { 'git', 'diff', 'master...', '--name-only' },
      results_title = '󰕜 master...',
    })
  end,
  { desc = 'Telescope git diff master' }
)

vim.keymap.set('n', '<leader>gt',
  function() require('telescope.builtin').git_bcommits({ results_title = ' commits' }) end,
  { desc = 'Telescope git commits' }
)

vim.keymap.set('n', 'gd',
  function() require('telescope.builtin').lsp_definitions({ results_title = ' LSP definitions' }) end,
  { desc = 'Telescope LSP definitions' }
)
vim.keymap.set('n', '<c-w>gd',
  function() require('telescope.builtin').lsp_definitions({ jump_type = 'vsplit', results_title = ' LSP definitions' }) end,
  { desc = 'Telescope LSP definitions (vertical split)' }
)
vim.keymap.set('n', 'gr',
  function() require('telescope.builtin').lsp_references({ results_title = ' LSP references' }) end,
  { desc = 'Telescope LSP references' }
)
vim.keymap.set('n', '<c-w>gr',
  function() require('telescope.builtin').lsp_references({ jump_type = 'vsplit', results_title = ' LSP references' }) end,
  { desc = 'Telescope LSP references (vertical split)' }
)
vim.keymap.set('n', '<c-q>',
  function()
    require('telescope.builtin').quickfix({
      results_title = '󰁨 quickfix',
      path_display = filename_first_and_shorten,
      show_line = false,
    })
  end,
  { desc = 'Telescope quickfix' }
)
vim.keymap.set('n', '<c-s-q>',
  function()
    require('telescope.builtin').quickfixhistory({
      results_title = '󰋚 quickfix history',
      layout_config = { preview_width = 0.55 },
    })
  end,
  { desc = 'Telescope quickfix history' }
)
vim.keymap.set('n', 'g?',
  function() require('telescope.builtin').spell_suggest() end,
  { desc = 'Telescope spell suggest' }
)

vim.schedule(function()
  telescope.load_extension('ui-select')
  telescope.load_extension('fzf')
end)
