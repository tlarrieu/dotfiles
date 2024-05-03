local o = vim.opt_local

o.concealcursor = 'cni'
o.formatprg = 'hindent'
o.cpoptions = o.cpoptions + 'M'

local runner = require('runner')

if require('helpers').fileexists('stack.yaml') then
  runner.default({
    main = runner.term('stack run'),
    alt = runner.term('stack test')
  })
else
  runner.default({
    main = runner.term('ghc -dynamic % && time ./%:t:r'),
  })
end

vim.keymap.set('n', '<leader>i', [[:silent call haskell#editImports('insert')<cr>]], { silent = true, buffer = true })
vim.keymap.set('n', '<leader>ei', [[:silent call haskell#editImports('normal')<cr>]], { silent = true, buffer = true })

vim.keymap.set('n', '<leader>è', [[:silent call haskell#editPragmas('insert')<cr>]], { silent = true, buffer = true })
vim.keymap.set('n', '<leader>eè', [[:silent call haskell#editPragmas('normal')<cr>]], { silent = true, buffer = true })

vim.keymap.set('n', '<leader>tu', [[:call haskell#ghci('tabnew')<cr>]], { silent = true, buffer = true })
vim.keymap.set('n', '<leader>vu', [[:call haskell#ghci('vnew')<cr>]], { silent = true, buffer = true })
vim.keymap.set('n', '<leader>nu', [[:call haskell#ghci('new')<cr>]], { silent = true, buffer = true })
