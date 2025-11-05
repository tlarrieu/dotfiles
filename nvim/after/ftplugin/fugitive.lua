vim.keymap.set('n', 'j', ']m', { remap = true, buffer = true }) -- previous file
vim.keymap.set('n', 'k', '[m', { remap = true, buffer = true }) -- next file
vim.keymap.set('n', 'p', 'dd', { remap = true, buffer = true }) -- split view diff
vim.keymap.set('n', 'gp', '=', { remap = true, buffer = true }) -- diff preview
vim.keymap.set('n', 'þ', ')', { remap = true, buffer = true })  -- next diff
vim.keymap.set('n', 'ß', '(', { remap = true, buffer = true })  -- previous diff
vim.keymap.set({ 'n', 'x' }, 'x', 'X', { remap = true, buffer = true })
vim.keymap.set('n', '<leader>l', '<cmd>bd<cr>', { buffer = true })

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
