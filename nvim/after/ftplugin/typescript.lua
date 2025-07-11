local o = vim.opt_local

o.conceallevel = 0
o.concealcursor = 'cni'
o.formatprg = 'prettier'

local runner = require('runner')
runner.default({ alt = runner.test.file })
runner.match({ '*.test.ts', '*.test.tsx', '*.spec.ts', '*.spec.tsx' }, {
  main = runner.test.nearest,
  alt = runner.test.file
})

require('utils').autoformat({ '*.ts', '*.tsx' })
