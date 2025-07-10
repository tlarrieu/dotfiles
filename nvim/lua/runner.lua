---@alias Runner { default: function, term: function, match: function, test: { nearest: function, file: function, last: function } }
local _M = {}

-- private

local _main = function(cmd)
  vim.keymap.set('n', '<cr>', cmd, { silent = true, buffer = true })
end

local _alt = function(cmd)
  vim.keymap.set('n', '<leader><cr>', cmd, { silent = true, buffer = true })
end

-- public

_M.term = function(cmd, opts)
  opts = opts or {}
  return function()
    vim.cmd.TermExec({
      'open=' .. ((opts.open == nil or opts.open == true) and 1 or 0),
      'direction="' .. (opts.direction or 'float') .. '"',
      'cmd="' .. cmd .. '"'
    })
  end
end

local wrap = function(fun)
  local required, testbus = pcall(require, 'testbus')
  if not required then return fun end
  return function() testbus.start(fun) end
end

_M.test = {
  nearest = function() return wrap(vim.cmd.TestNearest) end,
  file = function() return wrap(vim.cmd.TestFile) end,
  last = function() return wrap(vim.cmd.TestLast) end,
}

_M.default = function(opts)
  if opts.main then _main(opts.main) end
  if opts.alt then _alt(opts.alt) end
end

_M.match = function(pattern, opts)
  local group = vim.api.nvim_create_augroup(vim.inspect(pattern) .. '_runner_autocmd', {})

  vim.api.nvim_create_autocmd('BufEnter', {
    pattern = pattern,
    callback = function() _M.default(opts) end,
    group = group,
  })
end

return _M
