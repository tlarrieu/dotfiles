local M = {}

-- -----------------------------------------------------------------------------
-- config
-- -----------------------------------------------------------------------------

local config = {
  main = { keys = '<cr>' },
  alt = { keys = '<leader><cr>' },
  nearest = { keys = '<leader>tr' },
  file = { keys = '<leader>tf' },
  all = { keys = '<leader>ta' },
  repl = { keys = '<leader>vp' },

  show = { keys = '<c-.>' },
  last = { keys = '<leader>tl' },
  stop = { keys = '<leader>ts' },
}

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
  options = function(cfg) return set('options', cfg) or {} end,
  delete = function(key)
    assert(
      key == 'buffer' or key == 'window' or key == 'cmd' or key == 'pid' or key == 'options',
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
    vim.keymap.set('n', config.show.keys, '<cmd>:silent close!<cr>',
      { desc = 'Close task results', silent = true, buffer = state.buffer() })
    vim.keymap.set({ 'i', 't' }, config.show.keys, '<esc><cmd>:silent close!<cr>',
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

local run = function(options)
  if options then options = state.options(options) else options = state.options() end

  if options.cmd == nil then return warn('󱈸 No previous job found.') end
  if state.pid() then return warn(' Job already running...') end

  options.on_start = options.on_start or function() end
  options.on_stdout = options.on_stdout or function(_) end
  options.on_interrupt = options.on_interrupt or function() end
  options.on_clean = options.on_clean or function() end
  options.on_bufenter = options.on_bufenter or function() end

  local opened = state.window() ~= nil

  options.on_start()

  vim.api.nvim_win_call(window(), function()
    info('󰔟 Job started...')

    vim.wo.winbar = options.winbar or '󱤵 run'
    vim.bo[state.buffer()].modified = false
    vim.bo[state.buffer()].modifiable = false
    vim.api.nvim_create_autocmd('BufEnter', { callback = options.on_bufenter, buffer = state.buffer() })
    vim.api.nvim_create_autocmd('BufDelete', { callback = options.on_clean, buffer = state.buffer() })

    state.pid(
      vim.fn.jobstart(options.cmd, {
        term = true,
        on_stdout = function(_, data, _) options.on_stdout(data) end,
        on_exit = function(_, data, _)
          -- avoid losing the buffer when closing the window after <c-d>ing a prompt (any keypress on a finished session
          -- will destroy the buffer)
          vim.cmd.stopinsert()

          state.delete('pid')

          if data > 0 then
            options.on_interrupt()
            warn('󰚎 Job stopped with error.')
          else
            info('󱦟 Job complete.')
          end
        end,
      })
    )
    if not (opened or options.show) then vim.api.nvim_win_close(0, false) end
  end)

  return M
end

local show = function()
  if not state.buffer() then return warn('󱈸 Nothing to show.') end
  vim.api.nvim_set_current_win(window())
  return M
end

local bind = function(key, opts_or_fn, desc)
  vim.keymap.set('n', key,
    function() run(type(opts_or_fn) == 'function' and opts_or_fn() or opts_or_fn) end,
    { desc = desc, buffer = true })
end

local main = function(...) bind(config.main.keys, ...) end
local alt = function(...) bind(config.alt.keys, ...) end
local nearest = function(...) bind(config.nearest.keys, ...) end
local file = function(...) bind(config.file.keys, ...) end
local all = function(...) bind(config.all.keys, ...) end
local repl = function(opts_or_fn, desc)
  vim.keymap.set('n', config.repl.keys,
    function()
      vim.notify(vim.inspect(opts_or_fn))
      run(type(opts_or_fn) == 'function' and opts_or_fn() or opts_or_fn)
      show()
      vim.cmd.startinsert()
    end,
    { desc = desc, buffer = true })
end

local setup = function(options)
  local bufname = vim.api.nvim_buf_get_name(0)

  local cfg = {}

  for _, _cfg in ipairs(options.overrides or {}) do
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

  for _, name in ipairs({ 'main', 'alt', 'nearest', 'file', 'all', 'repl' }) do
    cfg[name] = cfg[name] or options[name]
  end

  if cfg.main then main(cfg.main.args, cfg.main.desc) end
  if cfg.alt then alt(cfg.alt.args, cfg.alt.desc) end
  if cfg.nearest then nearest(cfg.nearest.args, cfg.nearest.desc) end
  if cfg.file then file(cfg.file.args, cfg.file.desc) end
  if cfg.all then all(cfg.all.args, cfg.all.desc) end
  if cfg.repl then repl(cfg.repl.args, cfg.repl.desc) end
end

-- -----------------------------------------------------------------------------
-- setup
-- -----------------------------------------------------------------------------

vim.keymap.set('n', config.main.keys, function() warn('Main runner not configured') end, { desc = 'Runner (main)' })
vim.keymap.set('n', config.alt.keys, function() warn('Alt runner not configured') end, { desc = 'Runner (alt)' })
vim.keymap.set('n', config.nearest.keys, function() warn('Nearest test runner not defined') end,
  { desc = 'Run nearest test' })
vim.keymap.set('n', config.file.keys, function() warn('File test runner not defined') end, { desc = 'Run test file' })
vim.keymap.set('n', config.all.keys, function() warn('Global test runner not defined') end, { desc = 'Run test suite' })
vim.keymap.set('n', config.repl.keys, function() warn('REPL not defined') end, { desc = 'Start REPL' })

vim.keymap.set('n', config.last.keys, run, { desc = 'Re-start last run' })
vim.keymap.set('n', config.show.keys, show, { desc = 'Show run results' })
vim.keymap.set('n', config.stop.keys, function()
  pcall(vim.fn.jobstop, state.pid())
  pcall(state.options().on_clean)
end, { silent = true })

-- -----------------------------------------------------------------------------
-- public
-- -----------------------------------------------------------------------------

M = {
  run = run,
  show = show,
  setup = setup,
}

return M
