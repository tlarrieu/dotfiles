local o = vim.opt_local

o.conceallevel = 0
o.concealcursor = 'cni'
o.iskeyword = o.iskeyword + '?' + '!'
o.spell = true

local testbus = require('testbus')

local notify = function(msg, level) vim.notify(msg, level or vim.log.levels.WARN) end

local get_buffer = function()
  if not vim.g.testbuf or not vim.api.nvim_buf_is_valid(vim.g.testbuf) then
    vim.g.testbuf = vim.api.nvim_create_buf(true, true)
    vim.keymap.set('n', '<c-.>', '<cmd>:silent close!<cr>',
      { desc = 'Close test results', silent = true, buffer = vim.g.testbuf })
  end
  return vim.g.testbuf
end

local get_win = function()
  if vim.g.testwin and vim.api.nvim_win_is_valid(vim.g.testwin) then
    return vim.g.testwin
  end
  vim.g.testwin = vim.api.nvim_open_win(get_buffer(), false, { split = 'right' })
  vim.wo[vim.g.testwin].winbar = ' RSpec'
  return vim.g.testwin
end

local run = function(cmd)
  vim.g.testcmd = cmd or vim.g.testcmd

  if vim.g.testcmd == nil then
    notify('No test was previously run')
    return
  end

  testbus.start(function() end)

  local win = get_win()
  vim.api.nvim_win_call(win, function()
    if vim.g.testpid then return vim.notify('Test is already running', vim.log.levels.WARN) end
    vim.g.testpid = vim.fn.jobstart(vim.g.testcmd, {
      term = true,
      on_stdout = function(_, data, _) testbus.redraw(data) end,
      on_exit = function(_, data, _)
        if data > 0 then testbus.interrupt() end
        vim.api.nvim_win_close(get_win(), true)
        vim.g.testwin = nil
        vim.g.testpid = nil
      end,
    })
    vim.api.nvim_win_close(win, false)

    vim.keymap.set('n', '<leader>ts', function()
      pcall(vim.fn.jobstop, vim.g.testpid)
      testbus.clear()
      testbus.interrupt()
    end, { silent = true })

    vim.keymap.set('n', '<c-.>', function() if vim.g.testbuf then vim.api.nvim_set_current_win(get_win()) end end,
      { desc = 'Show test results' })
  end)
end

local build_cmd = function(opts)
  local fname = vim.api.nvim_buf_get_name(0)
  local line = vim.api.nvim_win_get_cursor(0)[1]

  local location = fname .. ((opts or {}).at_cursor and (':' .. line) or '')

  local cmd = { 'bundle', 'exec', 'rspec' }
  for _, option in ipairs(testbus.adapters.rspec.options) do table.insert(cmd, option) end
  if location then table.insert(cmd, location) end

  return cmd
end

if vim.api.nvim_buf_get_name(0):match('.*_spec.rb') then
  vim.keymap.set('n', '<leader>tr', function() run(build_cmd({ at_cursor = true })) end,
    { desc = 'Run nearest test', buffer = true })
  vim.keymap.set('n', '<leader>tf', function() run(build_cmd({ at_cursor = false })) end,
    { desc = 'Run test file', buffer = true })
else
  vim.keymap.set('n', '<leader>tr', function() notify('Not a test file') end,
    { desc = 'Run nearest test', buffer = true })
  vim.keymap.set('n', '<leader>tf', function() notify('Not a test file') end,
    { desc = 'Run test file', buffer = true })
end
vim.keymap.set('n', '<c-.>', function() notify('No test was previously run') end,
  { desc = 'Show test results' })
vim.keymap.set('n', '<leader>tl', run, { desc = 'Run test file' })
