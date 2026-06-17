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

vim.keymap.set('n', '<leader>cc', '<cmd>below Git commit<cr>',
  { silent = true, desc = 'Git commit (new)' })
vim.keymap.set('n', '<leader>ca', '<cmd>below Git commit --amend --no-edit<cr>',
  { silent = true, desc = 'Git commit (amend)' })
vim.keymap.set('n', '<leader>ce', '<cmd>below Git commit --amend<cr>',
  { silent = true, desc = 'Git commit (edit)' })

vim.keymap.set({ 'n', 'v' }, 'gy', ':GBrowse!<cr>', { silent = true, desc = 'Git(Hub) yank file/line URL' })

vim.keymap.set('n', '<leader>bo', ':Git pr<cr>', { silent = true, desc = 'Git pull request' })
vim.keymap.set('n', '<leader>bb', '<cmd>Telescope git_branches<cr>', { desc = 'Git branch' })
vim.keymap.set('n', '<leader>bl',
  function() require('telescope.builtin').git_branches({ show_remote_tracking_branches = false }) end,
  { desc = 'Git branch (local)' })

local async_run = function(cmd)
  return function()
    vim.notify('Running `' .. table.concat(cmd, ' ') .. '`...', vim.log.levels.INFO)
    vim.system(cmd, {},
      function(obj)
        if obj.code == 0 then return vim.notify(obj.stdout, vim.log.levels.INFO) end
        vim.notify(obj.stderr:gsub('error: ', ''), vim.log.levels.ERROR)
      end)
  end
end

vim.keymap.set('n', '<leader>gu', async_run({ 'git', 'pull', '--rebase' }),
  { silent = true, desc = 'Git pull' })
vim.keymap.set('n', '<leader>gp', async_run({ 'git', 'push', '--force-with-lease' }),
  { silent = true, desc = 'Git pull' })

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
    vim.keymap.set('n', 'S', '<cmd>Git add .<cr>', { buffer = true })
    vim.keymap.set('n', '<c-s>', '<cmd>q<cr>', { buffer = true })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'floggraph' },
  callback = function()
    vim.keymap.del('n', '<tab>', { buffer = true })
    vim.opt_local.listchars = {}
  end,
})
