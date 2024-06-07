local runner = require('runner')
runner.default({
  main = runner.shell({ 'sh', vim.fn.expand('%') }),
  alt = runner.term('sh %'),
})
