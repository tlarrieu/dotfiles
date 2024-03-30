local o = vim.opt_local

o.conceallevel = 0
o.concealcursor = 'cni'
o.iskeyword = o.iskeyword + '?' + '!' + ':'

local group = vim.api.nvim_create_augroup('RUBY_AUTOCMD', {})

vim.keymap.set('n', '<cr>', ':T ruby %<cr>', { silent = true, buffer = true })

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = { '*_spec.rb', '*_test.rb' },
  callback = function()
    vim.keymap.set('n', '<cr>', ':TestNearest | Topen<cr>', { silent = true, buffer = true })
    vim.keymap.set('n', '<leader><cr>', ':TestFile | Topen<cr>', { silent = true, buffer = true })
  end,
  group = group
})

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = { 'Gemfile', '*.gemspec' },
  callback = function()
    vim.keymap.set('n', '<cr>', 'T bundle<cr>', { silent = true, buffer = true })
  end,
  group = group
})

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = { 'config/routes.rb' },
  callback = function()
    vim.keymap.set('n', '<cr>', 'T rails routes<cr>', { silent = true, buffer = true })
  end,
  group = group
})
