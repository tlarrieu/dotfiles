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

local window = function()
  if not state.buffer() then
    state.buffer(vim.api.nvim_create_buf(true, true))
    vim.keymap.set('n', '<c-.>', '<cmd>:silent close!<cr>',
      { desc = 'Close task results', silent = true, buffer = state.buffer() })
    vim.keymap.set({ 'i', 't' }, '<c-.>', '<esc><cmd>:silent close!<cr>',
      { desc = 'Close task results', silent = true, buffer = state.buffer() })
  end

  if state.window() then return state.window() end

  state.window(vim.api.nvim_open_win(state.buffer(), false, { split = 'right' }))
  vim.api.nvim_create_autocmd('WinClosed', {
    pattern = { tostring(state.window()) },
    callback = function() state.delete('window') end,
  })
  return state.window()
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

    vim.wo.winbar = config.winbar or '󱤵 run'
    vim.bo[state.buffer()].modified = false
    vim.bo[state.buffer()].modifiable = false
    vim.api.nvim_create_autocmd('BufEnter', { callback = config.on_bufenter, buffer = state.buffer() })
    vim.api.nvim_create_autocmd('BufDelete', { callback = config.on_clean, buffer = state.buffer() })

    state.pid(
      vim.fn.jobstart(config.cmd, {
        term = true,
        on_stdout = function(_, data, _) config.on_stdout(data) end,
        on_exit = function(_, data, _)
          -- avoid losing the buffer when closing the window after <c-d>ing a prompt (any keypress on a finished session
          -- will destroy the buffer)
          vim.cmd.stopinsert()

          state.delete('pid')

          if data > 0 then
            config.on_interrupt()
            warn('󰚎 Job stopped with error.')
          else
            info('󱦟 Job complete.')
          end
        end,
      })
    )
    if not opened then vim.api.nvim_win_close(0, false) end
  end)
end

local show = function()
  if not state.buffer() then return warn('󱈸 Nothing to show.') end
  vim.api.nvim_set_current_win(window())
end

local bind = function(key, opts_or_fn, desc)
  vim.keymap.set('n', key,
    function() run(type(opts_or_fn) == 'function' and opts_or_fn() or opts_or_fn) end,
    { desc = desc, buffer = true })
end

local main = function(...) return bind('<cr>', ...) end
local alt = function(...) return bind('<leader><cr>', ...) end
local nearest = function(...) return bind('<leader>tr', ...) end
local file = function(...) return bind('<leader>tf', ...) end

-- -----------------------------------------------------------------------------
-- public
-- -----------------------------------------------------------------------------

M.setup = function(config)
  local bufname = vim.api.nvim_buf_get_name(0)

  local cfg = {}

  for _, _cfg in ipairs(config.overrides or {}) do
    if _cfg.patterns then
      for _, pattern in ipairs(_cfg.patterns) do
        if bufname:match(pattern) then
          cfg = {
            main = _cfg.main,
            alt = _cfg.alt,
            nearest = _cfg.nearest,
            file = _cfg.file,
          }
          break
        end
      end
    end
  end

  for _, name in ipairs({ 'main', 'alt', 'nearest', 'file' }) do
    cfg[name] = cfg[name] or config[name]
  end

  if cfg.main then main(cfg.main.args, cfg.main.desc) end
  if cfg.alt then alt(cfg.alt.args, cfg.alt.desc) end
  if cfg.nearest then nearest(cfg.nearest.args, cfg.nearest.desc) end
  if cfg.file then file(cfg.file.args, cfg.file.desc) end
end

-- -----------------------------------------------------------------------------
-- setup
-- -----------------------------------------------------------------------------

vim.keymap.set('n', '<cr>', function() warn('Main runner not configured') end, { desc = 'Runner (main)' })
vim.keymap.set('n', '<leader><cr>', function() warn('Alt runner not configured') end, { desc = 'Runner (alt)' })
vim.keymap.set('n', '<leader>tr', function() warn('Nearest test runner not defined') end, { desc = 'Run nearest test' })
vim.keymap.set('n', '<leader>tf', function() warn('File test runner not defined') end, { desc = 'Run test file' })

vim.keymap.set('n', '<leader>tl', run, { desc = 'Re-start last run' })
vim.keymap.set('n', '<c-.>', show, { desc = 'Show run results' })
vim.keymap.set('n', '<leader>ts', function()
  pcall(vim.fn.jobstop, state.pid())
  pcall(state.config().on_clean)
end, { silent = true })

return M
