local o = vim.opt_local

o.textwidth = 130
o.formatoptions = o.formatoptions + 't'
o.conceallevel = 2
o.spell = true

local group = vim.api.nvim_create_augroup('NeorgAutocmd', {})
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = { '**/gtd/index.norg' },
  callback = function()
    vim.keymap.set('n', 'o', 'i<c-cr>', { remap = true })
    vim.keymap.set('i', '<cr>', '<c-cr>', { remap = true })
  end,
  group = group
})
