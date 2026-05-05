local o = vim.opt_local

o.conceallevel = 0
o.concealcursor = 'cni'
o.iskeyword = o.iskeyword + '?' + '!'
o.spell = true

local testbus = require('testbus')

local warn = function(msg) vim.notify(msg, vim.log.levels.WARN) end
local info = function(msg) vim.notify(msg, vim.log.levels.INFO) end

vim.g.runner = vim.g.runner or {}

local set = function(key, value)
  local _state = vim.g.runner
  if value then _state[key] = value end
  vim.g.runner = _state
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
  config = function(cfg) return set('config', cfg) or {} end,
  delete = function(key)
    assert(
      key == 'buffer' or key == 'window' or key == 'cmd' or key == 'pid' or key == 'config',
      'Invalid state key: ' .. key
    )
    local _state = vim.g.runner
    _state[key] = nil
    vim.g.runner = _state
  end,
}

local function window()
  if not state.buffer() then
    state.buffer(vim.api.nvim_create_buf(true, true))
    vim.keymap.set('n', '<c-.>', '<cmd>:silent close!<cr>',
      { desc = 'Close task results', silent = true, buffer = state.buffer() })
    vim.keymap.set({ 'i', 't' }, '<c-.>', '<esc><cmd>:silent close!<cr>',
      { desc = 'Close task results', silent = true, buffer = state.buffer() })
  end

  if state.window() then return state.window() end

  state.window(vim.api.nvim_open_win(state.buffer(), false, { split = 'right' }))
  vim.wo[state.window()].winbar = state.config().winbar
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

local run = function(config)
  if config then config = state.config(config) else config = state.config() end

  if config.cmd == nil then return warn('󱈸 No previous job found.') end
  if state.pid() then return warn(' Job already running...') end

  config.on_start = config.on_start or function() end
  config.on_stdout = config.on_stdout or function(_) end
  config.on_interrupt = config.on_interrupt or function() end
  config.on_clean = config.on_clean or function() end
  config.on_bufenter = config.on_bufenter or function() end

  local opened = state.window() ~= nil

  config.on_start()

  vim.api.nvim_win_call(window(), function()
    info('󰔟 Job started...')

    vim.bo[state.buffer()].modified = false
    vim.bo[state.buffer()].modifiable = false

    vim.api.nvim_create_autocmd('BufEnter', { callback = config.on_bufenter, buffer = state.buffer() })
    vim.api.nvim_create_autocmd('BufDelete', { callback = config.on_clean, buffer = state.buffer() })

    state.pid(
      vim.fn.jobstart(config.cmd, {
        term = true,
        on_stdout = function(_, data, _) config.on_stdout(data) end,
        on_exit = function(_, data, _)
          if data > 0 then
            config.on_interrupt()
            warn('󰚎 Job stopped.')
          else
            info('󱦟 Job complete.')
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

vim.keymap.set('n', '<c-.>', function() vim.api.nvim_set_current_win(window()) end, { desc = 'Show run results' })
vim.keymap.set('n', '<leader>ts', function()
  local pid = state.pid()
  if pid then
    vim.fn.jobstop(pid)
    state.config().on_clean()
  else
    warn('No running job.')
  end
end, { silent = true })
vim.keymap.set('n', '<leader>tl', function() run() end, { desc = 'Re-start last run' })
