vim.g.flog_enable_extended_chars = true
vim.g.flog_default_opts = { format = '[%h]%d %s' }

vim.pack.add({
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/tpope/vim-rhubarb',
  'https://github.com/rbong/vim-flog',
}, { confirm = false })

vim.keymap.set('n', '<c-s>', '<cmd>below Git<cr>', { silent = true, desc = 'neogit' })

vim.keymap.set('n', '<leader>l', ':vertical Flogsplit<cr>', { silent = true, desc = 'Git log' })
vim.keymap.set('n', '<leader>L', ':vertical 0Flogsplit -no-patch<cr>', { silent = true, desc = 'Git history (file)' })
vim.keymap.set('v', '<leader>l', ':vertical Flogsplit -no-patch<cr>', { silent = true, desc = 'Git history (visual)' })

vim.keymap.set('n', '<leader>cc', '<cmd>below Git commit<cr>', { silent = true, desc = 'Git commit (new)' })
vim.keymap.set('n', '<leader>ca', '<cmd>below Git commit --amend --no-edit<cr>',
  { silent = true, desc = 'Git commit (amend)' })
vim.keymap.set('n', '<leader>ce', '<cmd>below Git commit --amend<cr>', { silent = true, desc = 'Git commit (edit)' })

vim.keymap.set({ 'n', 'v' }, 'gy', ':GBrowse!<cr>', { silent = true, desc = 'Git(Hub) yank file/line URL' })

vim.keymap.set('n', '<leader>bo', ':Git pr<cr>', { silent = true, desc = 'Git pull request' })
vim.keymap.set('n', '<leader>bb', '<cmd>Telescope git_branches<cr>', { desc = 'Git branch' })
vim.keymap.set('n', '<leader>bl',
  function() require('telescope.builtin').git_branches({ show_remote_tracking_branches = false }) end,
  { desc = 'Git branch (local)' })

vim.keymap.set('n', '<leader>gu', '<cmd>Git pull --rebase<cr>', { silent = true, desc = 'Git pull' })
vim.keymap.set('n', '<leader>gp', '<cmd>Git push --force-with-lease<cr>', { silent = true, desc = 'Git push' })
--
vim.keymap.set('n', '<leader>gs', ':silent !git stash --quiet<cr><cmd>checktime<cr>',
  { silent = true, desc = 'Git stash' })
vim.keymap.set('n', '<leader>gS', ':silent !git stash pop --quiet<cr><cmd>checktime<cr>',
  { silent = true, desc = 'Git stash pop' })

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'fugitive' },
  callback = function()
    vim.keymap.set('n', 'x', 'X', { remap = true, buffer = true })
    vim.keymap.set('n', 'o', '=', { remap = true, buffer = true })
    vim.keymap.set('n', 'þ', ']/', { remap = true, buffer = true })
    vim.keymap.set('n', 'ß', '[/', { remap = true, buffer = true })
    vim.keymap.set('n', 'S', '<cmd>Git add .<cr>')
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'floggraph' },
  callback = function()
    vim.keymap.del('n', '<tab>', { buffer = true })
    vim.opt.listchars = {}
  end,
})
