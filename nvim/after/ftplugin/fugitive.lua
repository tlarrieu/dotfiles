vim.keymap.set('n', 'j', ']m', { remap = true, buffer = true, desc = 'Prev file (fugitive)' })
vim.keymap.set('n', 'k', '[m', { remap = true, buffer = true, desc = 'Next file (fugitive)' })
vim.keymap.set('n', 'p', 'dd', { remap = true, buffer = true, desc = 'Diff (split view) (fugitive)' })
vim.keymap.set('n', 'gp', '=', { remap = true, buffer = true, desc = 'Diff preview (fugitive)' })
vim.keymap.set('n', 'þ', ')', { remap = true, buffer = true, desc = 'Next diff (fugitive)' })
vim.keymap.set('n', 'ß', '(', { remap = true, buffer = true, desc = 'Prev diff (fugitive)' })
vim.keymap.set({ 'n', 'x' }, 'x', 'X', { remap = true, buffer = true, desc = 'Discard (fugitive)' })
vim.keymap.set('n', '<leader>l', '<cmd>bd<cr>', { buffer = true, desc = 'Close (fugitive)' })

vim.keymap.set('n', 'cc', '<cmd>Git commit --quiet<cr>', {
  desc = 'Git commit',
  buffer = true,
})
vim.keymap.set('n', 'ca', '<cmd>Git commit --quiet --amend --no-edit<cr>', {
  desc = 'Git commit --amend --no-edit',
  buffer = true,
})
vim.keymap.set('n', 'cA', '<cmd>Git commit --quiet --amend<cr>', {
  desc = 'Git commit --amend',
  buffer = true,
})
