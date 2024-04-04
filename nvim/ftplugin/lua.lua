local runner = require('runner')

runner.default({ main = runner.term('lua %') })

-- TODO: make this more robust (if we are too “deep”, pattern does not get
-- triggered)
runner.match({ 'config/awesome/**/*.lua', 'config/awesome/*.lua' }, {
  main = runner.term('~/scripts/awesome-test')
})
