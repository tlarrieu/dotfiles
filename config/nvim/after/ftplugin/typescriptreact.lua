local o = vim.opt_local

o.conceallevel = 0
o.concealcursor = 'cni'
o.formatprg = 'prettier'

require('utils').autoformat({ '*.tsx' })

require('alternator').setup({
  { pattern = "(.*)/(.*)%.spec%.tsx", target = "%1/%2.tsx" },
  { pattern = "(.*)/(.*)%.tsx", target = "%1/%2.spec.tsx" },
})
