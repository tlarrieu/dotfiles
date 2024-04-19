local o = vim.opt_local

o.textwidth = 130
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
    o.foldlevel = 1
    vim.keymap.set('n', '<leader>z', ':set foldlevel=1<cr>zO', { remap = false, silent = true })
    vim.keymap.set('n', 'o', 'i<c-cr>', { remap = true })
    vim.keymap.set('i', '<cr>', '<c-cr>', { remap = true })
  end,
  group = group
})
