-- Format rules :
-- https://github.com/todotxt/todo.txt?tab=readme-ov-file#todotxt-format-rules

vim.opt_local.iskeyword = vim.opt_local.iskeyword + '@' + '-' + '+'
vim.opt_local.textwidth = 0
vim.opt_local.commentstring = 'x %s'
