local runner = require('runner')

runner.default({
  main = runner.term('psql -f ' .. vim.fn.expand('%')),
})

require('utils').autoformat({ '*.sql' })
