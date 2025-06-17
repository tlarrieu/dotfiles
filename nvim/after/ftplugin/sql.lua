local runner = require('runner')

runner.default({
  main = runner.term('psql -f ' .. vim.fn.expand('%')),
})
