local runner = require('runner')
runner.default({
  main = runner.term('sh %', false),
  alt = runner.term('sh %'),
})
