vim.keymap.set('n', 'k', '(', { remap = true, buffer = true })
vim.keymap.set('n', 'j', ')', { remap = true, buffer = true })
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
