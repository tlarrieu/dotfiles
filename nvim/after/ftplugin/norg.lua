local o = vim.opt_local

o.formatoptions = o.formatoptions + 't'
o.conceallevel = 2
o.spell = true

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = { '**/gtd/*.norg' },
  callback = function()
    vim.keymap.set('n', '<leader>z', '<cmd>set foldlevel=1<cr>zO', { remap = false, silent = true, buffer = true })
    vim.keymap.set('n', 'o', 'i<m-cr>( ) ', { remap = true, buffer = true })
    vim.keymap.set('i', '<cr>', '<m-cr>', { remap = true, buffer = true })

    vim.keymap.set('v', '<leader>b', 'S*ee', { buffer = true, remap = true })
    vim.keymap.set('v', '<leader>i', 'S/ee', { buffer = true, remap = true })
    vim.keymap.set('v', '<leader>u', 'S_ee', { buffer = true, remap = true })
    vim.keymap.set('v', '<leader>s', 'S-ee', { buffer = true, remap = true })
  end,
})

local task_actions = {
  ['<leader>td'] = 'done',
  ['<leader>tr'] = 'undone',
  ['<leader>tp'] = 'on-hold',
  ['<leader>ts'] = 'pending',
  ['<leader>tc'] = 'cancelled',
  ['gs'] = 'cycle',
  ['gS'] = 'cycle-reverse',
}
for key, value in pairs(task_actions) do
  vim.keymap.set('n', key, '<Plug>(neorg.qol.todo-items.todo.task-' .. value .. ')', { buffer = true })
end
