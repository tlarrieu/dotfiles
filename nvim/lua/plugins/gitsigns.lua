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

  -- those commits where tested to identify the most recent one that was not broken
  -- b014331: bad
  -- 1fcaddc: bad
  -- 6067670: good -- the commit we want
  -- 93f882f: good
  -- 7bf01f0: good
  -- aa49c96: good
  -- 1b0350a: good
  -- TODO: remove this once the issue is fixed
  commit = '6067670', -- pinned until the slowness of staging hunks has been resolved

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
    current_line_blame_formatter = '<abbrev_sha> <author>, <author_time:%R> — <summary>',
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

      local nav_hunk = function(dir)
        if vim.wo.diff then return vim.cmd.normal({ dir == 'prev' and '[c' or ']c', bang = true }) end
        gitsigns.nav_hunk(dir, { wrap = false, target = 'all' })
      end

      vim.keymap.set('n', 'ß', function() nav_hunk('prev') end, { desc = 'Previous hunk' })
      vim.keymap.set('n', 'þ', function() nav_hunk('next') end, { desc = 'Next hunk' })
      vim.keymap.set('n', '7', gitsigns.stage_hunk, { remap = true, desc = 'Toggle stage hunk' })
      vim.keymap.set('n', '8', gitsigns.reset_hunk, { remap = true, desc = 'Reset hunk' })

      local line_of = function(mark) return vim.api.nvim_buf_get_mark(0, mark)[1] end
      vim.keymap.set('x', '7', function()
        vim.cmd([[execute "normal! \<ESC>"]])
        gitsigns.stage_hunk({ line_of('<'), line_of('>') })
      end, { remap = true, desc = 'Toggle stage hunk (VISUAL)' })
      vim.keymap.set('x', '8', function()
        vim.cmd([[execute "normal! \<ESC>"]])
        gitsigns.reset_hunk({ line_of('<'), line_of('>') })
      end, { remap = true, desc = 'Reset hunk (VISUAL)' })

      local modes = { 'n', 'o', 'x' }
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
