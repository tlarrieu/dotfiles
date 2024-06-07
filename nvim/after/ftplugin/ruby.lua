local o = vim.opt_local

o.conceallevel = 0
o.concealcursor = 'cni'
o.iskeyword = o.iskeyword + '?' + '!' + ':'

local runner = require('runner')

runner.default({
  main = runner.shell({ 'ruby', vim.fn.expand('%') }),
  alt = runner.test.last(),
})

runner.match({ '*_spec.rb', '*_test.rb' }, {
  main = runner.test.nearest(),
  alt = runner.test.file()
})

runner.match({ 'Gemfile', '*.gemspec' }, { main = runner.term('bundle') })

runner.match('config/routes.rb', { main = runner.term('rails routes') })
