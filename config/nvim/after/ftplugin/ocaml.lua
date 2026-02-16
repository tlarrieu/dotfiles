local runner = require('runner')
local helpers = require('helpers')

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = { '*.ml' },
  callback = function()
    if helpers.fileexists('Makefile') then
      runner.default({
        main = runner.term('make'),
        alt = runner.term('make test'),
      })
    else
      runner.default({
        main = runner.term('ocaml %'),
      })
    end
  end,
  group = vim.api.nvim_create_augroup('ocaml_augroup', {})
})

vim.keymap.set('i', ',,', ';;', { silent = true, buffer = true })
