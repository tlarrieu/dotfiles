vim.pack.add({ 'https://github.com/esmuellert/codediff.nvim' }, { confirm = false })

require('codediff').setup({
  diff = {
    layout = 'inline',
    compute_moves = true,
    cycle_hunks_across_files = true,
  },
  explorer = {
    width = 45,
    icons = { folder_closed = '', folder_open = '' },
    view_mode = 'tree',
    flatten_dirs = true,
    file_filter = { ignore = { '*.pdf' } },
  },
  keymaps = {
    view = { next_hunk = 'þ', prev_hunk = 'ß', next_file = '<c-n>', prev_file = '<c-p>' },
  },
  highlights = {
    line_move = 'DiffMove',
  }
})

vim.keymap.set('n', '<leader>dm', '<cmd>CodeDiff origin/master...<cr>',
  { silent = true, desc = 'code(diff) review (origin/master...)' })
vim.keymap.set('n', '<leader>dd', '<cmd>CodeDiff HEAD<cr>', { silent = true, desc = 'code(diff) review (HEAD~)' })
