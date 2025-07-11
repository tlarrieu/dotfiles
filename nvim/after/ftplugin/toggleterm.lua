vim.opt_local.list = false

local runner = require('runner')

runner.default({
  alt = runner.test.last,
})
