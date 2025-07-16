---@alias command string|fun()

---@class Runner
---@field default fun(opts: { main: command, alt: command })
---@field term fun(cmd: string, opts?: {}): fun()
---@field match fun(pattern: string, opts?: { main: command, alt: command})
local M = {}

-- private

---@param cmd command
local _main = function(cmd)
  vim.keymap.set('n', '<cr>', cmd, { silent = true, buffer = true })
end

---@param cmd command
local _alt = function(cmd)
  vim.keymap.set('n', '<leader><cr>', cmd, { silent = true, buffer = true })
end

-- public

M.term = function(cmd, opts)
  opts = opts or {}
  return function()
    vim.cmd.TermExec({
      'open=' .. ((opts.open == nil or opts.open == true) and 1 or 0),
      'direction="' .. (opts.direction or 'float') .. '"',
      'cmd="' .. cmd .. '"'
    })
  end
end

M.default = function(opts)
  if opts.main then _main(opts.main) end
  if opts.alt then _alt(opts.alt) end
end

M.match = function(pattern, opts)
  local group = vim.api.nvim_create_augroup(vim.inspect(pattern) .. '_runner_autocmd', {})

  vim.api.nvim_create_autocmd('BufEnter', {
    pattern = pattern,
    callback = function() M.default(opts) end,
    group = group,
  })
end

return M
