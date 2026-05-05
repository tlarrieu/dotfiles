local o = vim.opt_local

o.conceallevel = 0
o.concealcursor = 'cni'
o.iskeyword = o.iskeyword + '?' + '!'
o.spell = true

local runner = require('runner2')

local rspec = function(opts)
  local testbus = require('testbus')

  opts = opts or {}

  local fname = vim.api.nvim_buf_get_name(0)
  local line = vim.api.nvim_win_get_cursor(0)[1]

  local cmd = { 'bundle', 'exec', 'rspec' }
  for _, option in ipairs(testbus.adapters.rspec.options) do table.insert(cmd, option) end

  local location = fname .. (opts.at_cursor and (':' .. line) or '')
  if location then table.insert(cmd, location) end

  return {
    on_start = testbus.start,
    on_stdout = testbus.redraw,
    on_interrupt = testbus.interrupt,
    on_clean = function()
      testbus.interrupt()
      testbus.clear()
    end,
    on_bufenter = function() if testbus.is_awaiting() then vim.cmd.startinsert() end end,
    winbar = ' RSpec',
    cmd = cmd,
  }
end

if vim.api.nvim_buf_get_name(0):match('.*_spec.rb') then
  vim.keymap.set('n', '<leader>tr', function() runner.run(rspec({ at_cursor = true })) end,
    { desc = 'Run nearest test', buffer = true })
  vim.keymap.set('n', '<leader>tf', function() runner.run(rspec({ at_cursor = false })) end,
    { desc = 'Run test file', buffer = true })
end
