local runner = require('runner')

runner.default({
  main = runner.shell({ 'lua', '%' }),
  alt = runner.term('lua %'),
})

runner.match({ 'config/awesome/**/*.lua', 'config/awesome/*.lua' }, {
  main = runner.shell({ 'sh', vim.fn.expand('~/scripts/awesome-test') }),
  alt = runner.term('~/scripts/awesome-test'),
})

require('utils').autoformat('*.lua')
