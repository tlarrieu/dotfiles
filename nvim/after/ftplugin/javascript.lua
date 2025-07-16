vim.opt_local.spell = true

local runner = require('runner')
runner.default({
  main = runner.term('node %'),
})
