local runner = require('runner')

runner.default({ main = runner.term('lua %') })

runner.match({ 'config/awesome/**/*.lua', 'config/awesome/*.lua' }, {
  main = runner.term('~/scripts/awesome-test')
})
