local o = vim.opt_local

o.conceallevel = 0
o.concealcursor = 'cni'
o.iskeyword = o.iskeyword + '?' + '!'
o.spell = true

local group = vim.api.nvim_create_augroup('ruby_autocmd', {})
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = { '*.rb' },
  callback = function() o.indentkeys:remove({ '.', ':' }) end,
  group = group
})

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

local alternate = function()
  local path = vim.api.nvim_buf_get_name(0)
  local alt
  if path:match("spec") then
    alt = path
        :gsub("(.*)/spec/requests/(.*)_spec%.rb", "%1/app/controllers/%2.rb")
        :gsub("(.*)/spec/(.*)_spec%.rb", "%1/app/%2.rb")
  else
    alt = path
        :gsub("(.*)/app/controllers/(.*)%.rb", "%1/spec/requests/%2_spec.rb")
        :gsub("(.*)/app/(.*)%.rb", "%1/spec/%2_spec.rb")
  end
  vim.cmd.edit(alt)
end

vim.keymap.set('n', '<c-$>', alternate, { silent = false })
