require('utils').autocapitalize({ '*.tex', '*.latex' })

local runner = require('runner')
runner.default({
  main = runner.term('make', { open = false }),
  alt = runner.term('xelatex % -o output.pdf', { open = false }),
})
