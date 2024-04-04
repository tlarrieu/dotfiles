local o = vim.opt_local

o.concealcursor = 'cni'
o.formatprg = 'hindent'
o.cpoptions = o.cpoptions + 'M'

local runner = require('runner')

if require('helpers').filexists('stack.yaml') then
  runner.default({
    main = runner.exec('call haskell#run()'),
    alt = runner.exec('call haskell#test()')
  })
else
  runner.default({
    main = runner.exec([[:execute "T echo -ne '\\033c'; ghc -dynamic % && time ./%:t:r"<cr>]]),
  })
end

vim.keymap.set('n', '<leader>i', [[:silent call haskell#editImports('insert')<cr>]], { silent = true, buffer = true })
vim.keymap.set('n', '<leader>ei', [[:silent call haskell#editImports('normal')<cr>]], { silent = true, buffer = true })

vim.keymap.set('n', '<leader>è', [[:silent call haskell#editPragmas('insert')<cr>]], { silent = true, buffer = true })
vim.keymap.set('n', '<leader>eè', [[:silent call haskell#editPragmas('normal')<cr>]], { silent = true, buffer = true })

vim.keymap.set('n', '<leader>tu', [[:call haskell#ghci('tabnew')<cr>]], { silent = true, buffer = true })
vim.keymap.set('n', '<leader>vu', [[:call haskell#ghci('vnew')<cr>]], { silent = true, buffer = true })
vim.keymap.set('n', '<leader>nu', [[:call haskell#ghci('new')<cr>]], { silent = true, buffer = true })
