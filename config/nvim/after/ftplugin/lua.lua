local runner = require('runner')

runner.default({
  main = runner.term('lua ' .. '%', { open = false }),
  alt = runner.term('lua %'),
})

runner.match({ 'config/awesome/**/*.lua', 'config/awesome/*.lua' }, {
  main = runner.term('sh ' .. vim.fn.expand('~/scripts/awesome-test'), { open = false }),
  alt = runner.term('~/scripts/awesome-test'),
})

require('utils').autoformat('*.lua')
