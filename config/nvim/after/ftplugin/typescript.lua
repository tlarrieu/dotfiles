local o = vim.opt_local

o.conceallevel = 0
o.concealcursor = 'cni'
o.formatprg = 'prettier'

require('utils').autoformat({ '*.ts' })

require('alternator').setup({
  { pattern = "(.*)/(.*)%.spec%.ts", target = "%1/%2.ts" },
  { pattern = "(.*)/(.*)%.ts", target = "%1/%2.spec.ts" },
})
