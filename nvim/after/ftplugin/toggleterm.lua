local runner = require('runner')

runner.default({
  alt = runner.test.last(),
})
