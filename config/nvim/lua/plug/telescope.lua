vim.pack.add({
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/nvim-telescope/telescope-ui-select.nvim',
  { src = 'https://github.com/nvim-telescope/telescope-fzf-native.nvim', data = { build = 'make' } },
}, { confirm = false })

local border = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' }

local h = require('helpers')

local find_files = function() return { 'fd', '-tf', '--hidden', h.fileexists('.ignore') and '--no-ignore-vcs' or '' } end
local find_directories = function() return { 'fd', '-td', '--hidden', h.fileexists('.ignore') and '--no-ignore-vcs' or '' } end

local telescope = require('telescope')
local actions = require('telescope.actions')

telescope.setup({
  defaults = {
    border = true,
    borderchars = border,
    dynamic_preview_title = true,

    file_ignore_patterns = { '^%.git/', '%.png', '%.jpg' },

    prompt_prefix = '   ',
    selection_caret = ' 󰫈  ',
    entry_prefix = ' 󰋙  ',
    multi_icon = ' 󰁘  ',

    path_display = { 'filename_first', shorten = { len = 1, exclude = { 1, -3, -2, -1 } } },

    sorting_strategy = 'ascending',
    layout_config = {
      prompt_position = 'top',
      anchor = 'S',
      anchor_padding = 0,
      preview_width = 0.65,
      height = 30,
      width = 174,
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
        borderchars = border,
        layout_strategy = 'horizontal',
      })
    },
    fzf = { fuzzy = false },
  }
})

local t = require('telescope.builtin')

vim.keymap.set('n', '<c-è>', t.resume, { desc = 'Telescope resume' })

vim.keymap.set('n', '<leader>ep', function()
  t.find_files({
    hidden = true,
    find_command = { 'fd', '-td', '.', vim.fs.joinpath(vim.fn.stdpath('data'), 'site', 'pack', 'core', 'opt'), '-d', '1' },
    results_title =
    '󱏒 files'
  })
end, { desc = 'Telescope file finder' })

vim.keymap.set('n', '<c-t>', function()
  t.find_files({ hidden = true, find_command = find_files, results_title = '󱏒 files' })
end, { desc = 'Telescope file finder' })

vim.keymap.set('n', '<a-t>', function()
  t.find_files({ hidden = true, find_command = find_directories, results_title = '󰙅 directories' })
end, { desc = 'Telescope directories finder' })

vim.keymap.set('n', '<c-y>', function()
  t.find_files({ hidden = true, find_command = { 'git', 'ls-status' }, results_title = '󰊢 status' })
end, { desc = 'Telescope directories finder' })

vim.keymap.set('n', '<c-s-y>', function()
  t.find_files({
    hidden = true,
    find_command = { 'git', 'diff', 'master...', '--name-only' },
    results_title = '󰊢 diff master...',
  })
end, { desc = 'Telescope git diff master' })

vim.keymap.set('n', '<c-b>',
  function() t.buffers({ hidden = true, ignore_current_buffer = true, sort_mru = true, results_title = ' buffers' }) end,
  { desc = 'Telescope buffers' })

vim.keymap.set('n', '<c-l>', function() t.registers({ results_title = ' registers' }) end,
  { desc = 'Telescope registers' })

vim.keymap.set('n', '<c-h>', function() t.help_tags({ results_title = ' documentation' }) end,
  { desc = 'Telescope help tags' })

vim.keymap.set('n', '<c-q>', function()
  t.quickfix({ results_title = '󰁨 quickfix', show_line = false })
end, { desc = 'Telescope quickfix' })

vim.keymap.set('n', '<c-s-q>',
  function() t.quickfixhistory({ results_title = '󰋚 quickfix history', layout_config = { preview_width = 0.55 } }) end,
  { desc = 'Telescope quickfix history' })

vim.keymap.set('n', 'g?', function() t.spell_suggest() end, { desc = 'Telescope spell suggest' })

pcall(telescope.load_extension, 'ui-select')
pcall(telescope.load_extension, 'fzf')
