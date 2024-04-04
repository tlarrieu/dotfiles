local o = vim.opt_local

o.conceallevel = 0
o.concealcursor = 'cni'
o.formatprg = 'prettier'

local runner = require('runner')
runner.default({ alt = runner.test.file() })
runner.match('*.test.ts', {
    main = runner.test.nearest(),
    alt = runner.test.file()
})
