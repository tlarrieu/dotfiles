require('utils').autocapitalize({ '*.tex', '*.latex' })

local runner = require('runner')
runner.default({
  main = runner.term('just build', { open = false }),
  alt = runner.term('just preview', { open = false }),
})
