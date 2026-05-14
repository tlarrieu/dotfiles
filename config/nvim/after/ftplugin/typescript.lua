local o = vim.opt_local

o.conceallevel = 0
o.concealcursor = 'cni'
o.formatprg = 'prettier'

require('utils').autoformat({ '*.ts', '*.tsx' })

require('alternator').setup({
  { pattern = "(.*)/(.*)%.spec%.ts", target = "%1/%2.ts" },
  { pattern = "(.*)/(.*)%.ts", target = "%1/%2.spec.ts" },
  { pattern = "(.*)/(.*)%.spec%.tsx", target = "%1/%2.tsx" },
  { pattern = "(.*)/(.*)%.tsx", target = "%1/%2.spec.tsx" },
})
