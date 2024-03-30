local group = vim.api.nvim_create_augroup('TEX_AUTOCMD', {})

vim.api.nvim_create_autocmd('InsertCharPre', {
  pattern = { '*.tex', '*.latex' },
  command = "call helpers#Capitalize()",
  group = group
})

vim.keymap.set('n', '<cr>', ':T xelatex % -o output.pdf<cr>', { silent = true, buffer = true })
