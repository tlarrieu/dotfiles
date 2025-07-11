vim.opt_local.spell = true

local runner = require('runner')
runner.default({
  main = runner.term('node %'),
  alt = runner.test.last,
})
runner.match('*.spec.js', {
  main = runner.test.nearest,
  alt = runner.test.file
})
