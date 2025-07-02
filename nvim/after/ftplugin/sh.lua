local runner = require('runner')
runner.default({
  main = runner.term('sh %', { open = false }),
  alt = runner.term('sh %'),
})
