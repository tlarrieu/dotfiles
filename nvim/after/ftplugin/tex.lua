require('utils').autocapitalize({ '*.tex', '*.latex' })

local runner = require('runner')
runner.default({
  main = runner.term('make', false),
  alt = runner.term('xelatex % -o output.pdf', false),
})
