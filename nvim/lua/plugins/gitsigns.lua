local signs = {
  add          = { text = '┃󰐕' },
  change       = { text = '┃~' },
  delete       = { text = '┃_' },
  topdelete    = { text = '┃‾' },
  changedelete = { text = '┃󰦒' },
  untracked    = { text = '╏󰐕' },
}

return {
  'lewis6991/gitsigns.nvim',
  event = { 'BufNew', 'BufReadPost' },
  opts = {
    signs                        = signs,
    signs_staged                 = signs,
    signs_staged_enable          = true,
    signcolumn                   = true,
    numhl                        = true,
    linehl                       = false,
    word_diff                    = false,
    watch_gitdir                 = { follow_files = true },
    auto_attach                  = true,
    attach_to_untracked          = true,
    current_line_blame           = false,
    current_line_blame_opts      = {
      virt_text = true,
      virt_text_pos = 'eol',
      delay = 50,
      ignore_whitespace = false,
      virt_text_priority = 100,
      use_focus = true,
    },
    current_line_blame_formatter = '<abbrev_sha> <author>, <author_time:%R> - <summary>',
    sign_priority                = 6,
    update_debounce              = 100,
    status_formatter             = nil,
    max_file_length              = 40000,
    preview_config               = {
      -- Options passed to nvim_open_win
      border = 'single',
      style = 'minimal',
      relative = 'cursor',
      row = 0,
      col = 1
    },
    on_attach                    = function()
      local gitsigns = require('gitsigns')
      local navopts = { wrap = false, target = 'all' }
      local modes = { 'n', 'o', 'x' }

      local prev_hunk = function()
        if vim.wo.diff then vim.cmd.normal({ '[c', bang = true }) else gitsigns.nav_hunk('prev', navopts) end
      end
      local next_hunk = function()
        if vim.wo.diff then vim.cmd.normal({ ']c', bang = true }) else gitsigns.nav_hunk('next', navopts) end
      end

      vim.keymap.set('n', 'ß', prev_hunk, { desc = 'Previous hunk' })
      vim.keymap.set('n', 'þ', next_hunk, { desc = 'Next hunk' })
      vim.keymap.set('n', '7', gitsigns.stage_hunk, { remap = true, desc = 'Toggle stage hunk' })
      vim.keymap.set('n', '8', gitsigns.reset_hunk, { remap = true, desc = 'Reset hunk' })
      vim.keymap.set(modes, '<leader>gb', gitsigns.blame, { desc = 'Blame (buffer)' })
      vim.keymap.set(modes, '<leader>gB', gitsigns.toggle_current_line_blame, { desc = 'Blame (line)' })
      vim.keymap.set(modes, '<leader>gw', gitsigns.stage_buffer, { desc = 'Stage all hunks' })
      vim.keymap.set(modes, '<leader>gR', gitsigns.reset_buffer_index, { remap = true, desc = 'Git reset' })
      vim.keymap.set(modes, '<leader>gq', function()
        gitsigns.setqflist('all')
      end, { remap = true, desc = 'Git reset' })
    end
  }
}
