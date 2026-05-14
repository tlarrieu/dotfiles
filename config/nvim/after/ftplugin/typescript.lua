vim.opt_local.conceallevel = 0
vim.opt_local.concealcursor = 'cni'
vim.opt_local.formatprg = 'prettier'

require('alternator').setup({
  { pattern = "(.*)/(.*)%.spec%.ts", target = "%1/%2.ts" },
  { pattern = "(.*)/(.*)%.ts", target = "%1/%2.spec.ts" },
  { pattern = "(.*)/(.*)%.spec%.tsx", target = "%1/%2.tsx" },
  { pattern = "(.*)/(.*)%.tsx", target = "%1/%2.spec.tsx" },
})
