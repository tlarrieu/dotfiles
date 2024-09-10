local o = vim.opt_local
o.commentstring = '; %s'
o.iskeyword = o.iskeyword + ':' + '/'
o.expandtab = true
o.tabstop = 2
o.shiftwidth = 2
o.shiftround = true

local runner = require('runner')
runner.default({
  main = runner.term('ft now'),
  alt = runner.term('ft up'),
})
