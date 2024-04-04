vim.fn['gnuplot#setup']()

local runner = require('runner')
runner.default({
  main = runner.exec('Plot bars'),
  alt = runner.exec('Plot lines')
})
