local M = {}

-- -----------------------------------------------------------------------------
-- private
-- -----------------------------------------------------------------------------

vim.g.runner = vim.g.runner or {}

local warn = function(msg) vim.notify(msg, vim.log.levels.WARN) end
local info = function(msg) vim.notify(msg, vim.log.levels.INFO) end

local set = function(key, value)
  local _state = vim.g.runner
  if value then _state[key] = value end
  vim.g.runner = _state
  return _state[key]
end

local window = function()
  if not M.state.buffer() then
    M.state.buffer(vim.api.nvim_create_buf(true, true))
    vim.keymap.set('n', '<c-.>', '<cmd>:silent close!<cr>',
      { desc = 'Close task results', silent = true, buffer = M.state.buffer() })
    vim.keymap.set({ 'i', 't' }, '<c-.>', '<esc><cmd>:silent close!<cr>',
      { desc = 'Close task results', silent = true, buffer = M.state.buffer() })
  end

  if M.state.window() then return M.state.window() end

  M.state.window(vim.api.nvim_open_win(M.state.buffer(), false, { split = 'right' }))
  vim.wo[M.state.window()].winbar = M.state.config().winbar
  return M.state.window()
end

-- -----------------------------------------------------------------------------
-- public
-- -----------------------------------------------------------------------------

M.state = {
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

M.run = function(config)
  if config then config = M.state.config(config) else config = M.state.config() end

  if config.cmd == nil then return warn('󱈸 No previous job found.') end
  if M.state.pid() then return warn(' Job already running...') end

  config.on_start = config.on_start or function() end
  config.on_stdout = config.on_stdout or function(_) end
  config.on_interrupt = config.on_interrupt or function() end
  config.on_clean = config.on_clean or function() end
  config.on_bufenter = config.on_bufenter or function() end

  local opened = M.state.window() ~= nil

  config.on_start()

  vim.api.nvim_win_call(window(), function()
    info('󰔟 Job started...')

    vim.bo[M.state.buffer()].modified = false
    vim.bo[M.state.buffer()].modifiable = false

    vim.api.nvim_create_autocmd('BufEnter', { callback = config.on_bufenter, buffer = M.state.buffer() })
    vim.api.nvim_create_autocmd('BufDelete', { callback = config.on_clean, buffer = M.state.buffer() })

    M.state.pid(
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

          if M.state.window() ~= nil then
            vim.api.nvim_win_close(M.state.window(), true)
            M.state.delete('window')
          end

          M.state.delete('pid')
        end,
      })
    )
    if not opened then vim.api.nvim_win_close(0, false) end
  end)
end

M.show = function() vim.api.nvim_set_current_win(window()) end

-- -----------------------------------------------------------------------------
-- setup
-- -----------------------------------------------------------------------------

vim.keymap.set('n', '<leader>tl', M.run, { desc = 'Re-start last run' })
vim.keymap.set('n', '<leader>tr', function() warn('Not a test file') end, { desc = 'Run nearest test' })
vim.keymap.set('n', '<leader>tf', function() warn('Not a test file') end, { desc = 'Run test file' })
vim.keymap.set('n', '<c-.>', M.show, { desc = 'Show run results' })
vim.keymap.set('n', '<leader>ts', function()
  pcall(vim.fn.jobstop, M.state.pid())
  M.state.config().on_clean()
end, { silent = true })

return M
