local o = vim.opt_local

o.conceallevel = 0
o.concealcursor = 'cni'
o.formatprg = 'prettier'

require('utils').autoformat({ '*.ts' })

vim.keymap.set('n', '<c-$>', function()
  require('alternator').alternate({
    { pattern = "(.*)/(.*)%.spec%.ts", target = "%1/%2.ts" },
    { pattern = "(.*)/(.*)%.ts", target = "%1/%2.spec.ts" },
  })
end, { silent = true, buffer = true })
