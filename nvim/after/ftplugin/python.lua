local runner = require('runner')

runner.default({
  main = runner.term('python %'),
  alt = runner.test.last,
})

runner.match({ 'test*.py', '*_unittest.py' }, {
  main = runner.test.nearest,
  alt = runner.test.file
})
