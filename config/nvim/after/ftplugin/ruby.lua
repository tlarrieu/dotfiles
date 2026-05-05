local o = vim.opt_local

o.conceallevel = 0
o.concealcursor = 'cni'
o.iskeyword = o.iskeyword + '?' + '!'
o.spell = true

local testbus = require('testbus')

local warn = function(msg) vim.notify(msg, vim.log.levels.WARN) end
local info = function(msg) vim.notify(msg, vim.log.levels.INFO) end

vim.g.testbus = vim.g.testbus or {}

local set = function(key, value)
  local _state = vim.g.testbus
  if value then _state[key] = value end
  vim.g.testbus = _state
  return _state[key]
end

local state = {
  buffer = function(buf)
    local _buf = set('buffer', buf)
    if _buf and vim.api.nvim_buf_is_valid(_buf) then return _buf end
    return nil
  end,
  window = function(win)
    local _win = set('window', win)
    if _win and vim.api.nvim_win_is_valid(_win) then return _win end
    return nil
  end,
  cmd = function(cmd) return set('cmd', cmd) end,
  pid = function(id) return set('pid', id) end,
  delete = function(key)
    assert(key == 'buffer' or key == 'window' or key == 'cmd' or key == 'pid')
    local _state = vim.g.testbus
    _state[key] = nil
    vim.g.testbus = _state
  end,
}

local function window()
  if not state.buffer() then
    state.buffer(vim.api.nvim_create_buf(true, true))
    vim.keymap.set('n', '<c-.>', '<cmd>:silent close!<cr>',
      { desc = 'Close test results', silent = true, buffer = state.buffer() })
    vim.keymap.set({ 'i', 't' }, '<c-.>', '<esc><cmd>:silent close!<cr>',
      { desc = 'Close test results', silent = true, buffer = state.buffer() })
  end

  if state.window() then return state.window() end

  state.window(vim.api.nvim_open_win(state.buffer(), false, { split = 'right' }))
  vim.wo[state.window()].winbar = ' RSpec'
  return state.window()
end

local rspec = function(opts)
  opts = opts or {}

  local fname = vim.api.nvim_buf_get_name(0)
  local line = vim.api.nvim_win_get_cursor(0)[1]

  local cmd = { 'bundle', 'exec', 'rspec' }
  for _, option in ipairs(testbus.adapters.rspec.options) do table.insert(cmd, option) end

  local location = fname .. (opts.at_cursor and (':' .. line) or '')
  if location then table.insert(cmd, location) end

  return state.cmd(cmd)
end

local run = function(cmd)
  if cmd == nil then return warn('No test was previously run') end

  testbus.start(function() end)

  local opened = state.window() ~= nil

  vim.api.nvim_win_call(window(), function()
    if state.pid() then return warn('Test is already running') end

    info('󰔟 Tests started...')

    vim.bo[state.buffer()].modified = false
    vim.bo[state.buffer()].modifiable = false
    state.pid(
      vim.fn.jobstart(cmd, {
        term = true,
        on_stdout = function(_, data, _) testbus.redraw(data) end,
        on_exit = function(_, data, _)
          if data > 0 then
            testbus.interrupt()
            warn('󰚎 Tests interrupted')
          else
            info('󱦟 Tests ended')
          end

          if state.window() ~= nil then
            vim.api.nvim_win_close(state.window(), true)
            state.delete('window')
          end

          state.delete('pid')
        end,
      })
    )
    if not opened then vim.api.nvim_win_close(0, false) end

    vim.keymap.set('n', '<leader>ts', function()
      pcall(vim.fn.jobstop, state.pid())
      testbus.clear()
      testbus.interrupt()
    end, { silent = true })

    vim.keymap.set('n', '<c-.>', function()
      vim.api.nvim_set_current_win(window())
      if testbus.is_awaiting() then vim.cmd.startinsert() end
    end, { desc = 'Show test results' })
  end)
end

if vim.api.nvim_buf_get_name(0):match('.*_spec.rb') then
  vim.keymap.set('n', '<leader>tr', function() run(rspec({ at_cursor = true })) end,
    { desc = 'Run nearest test', buffer = true })
  vim.keymap.set('n', '<leader>tf', function() run(rspec({ at_cursor = false })) end,
    { desc = 'Run test file', buffer = true })
else
  vim.keymap.set('n', '<leader>tr', function() warn('Not a test file') end,
    { desc = 'Run nearest test', buffer = true })
  vim.keymap.set('n', '<leader>tf', function() warn('Not a test file') end,
    { desc = 'Run test file', buffer = true })
end
vim.keymap.set('n', '<c-.>', function() warn('No test was previously run') end,
  { desc = 'Show test results' })
vim.keymap.set('n', '<leader>tl', function() run(state.cmd()) end, { desc = 'Run test file' })
