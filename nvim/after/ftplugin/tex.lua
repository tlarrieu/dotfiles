require('utils').autocapitalize({ '*.tex', '*.latex' })

local runner = require('runner')
runner.default({
  main = runner.shell({ 'make' }),
  alt = runner.term('xelatex % -o output.pdf'),
})
