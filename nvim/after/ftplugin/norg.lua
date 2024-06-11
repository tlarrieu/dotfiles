local o = vim.opt_local

o.formatoptions = o.formatoptions + 't'
o.conceallevel = 2
o.spell = true
o.foldmethod = 'expr'
o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
o.foldlevel = 5
o.foldenable = true

local group = vim.api.nvim_create_augroup('NeorgAutocmd', {})
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = { '**/gtd/index.norg' },
  callback = function()
    vim.keymap.set('n', '<leader>z', ':set foldlevel=1<cr>zO', { remap = false, silent = true, buffer = true })
    vim.keymap.set('n', 'o', 'i<c-cr>', { remap = true, buffer = true })
    vim.keymap.set('i', '<cr>', '<c-cr>', { remap = true, buffer = true })

    vim.keymap.set('v', '<leader>b', 'S*ee', { buffer = true, remap = true })
    vim.keymap.set('v', '<leader>i', 'S/ee', { buffer = true, remap = true })
    vim.keymap.set('v', '<leader>u', 'S_ee', { buffer = true, remap = true })
    vim.keymap.set('v', '<leader>s', 'S-ee', { buffer = true, remap = true })
  end,
  group = group
})
