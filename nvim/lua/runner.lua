local _M = {}

-- private

local _main = function(cmd)
  vim.keymap.set('n', '<cr>', cmd, { silent = true, buffer = true })
end

local _alt = function(cmd)
  vim.keymap.set('n', '<leader><cr>', cmd, { silent = true, buffer = true })
end

-- public

_M.term = function(cmd)
  return ":TermExec cmd='" .. cmd .. "'<cr>"
end

-- TODO: make this async
_M.shell = function(cmd)
  return function()
    local res = vim.system(cmd, { text = true }):wait()

    if res.stdout ~= '' then
      vim.notify(res.stdout)
    end

    if res.stderr ~= '' then
      vim.notify(res.stderr, vim.log.levels.ERROR)
    end

    vim.notify('done.', vim.log.levels.INFO)
  end
end

_M.exec = function(cmd)
  return ':' .. cmd .. '<cr>'
end

_M.test = {
  nearest = function() return ':TestNearest<cr>' end,
  file = function() return ':TestFile<cr>' end,
  last = function() return ':TestLast<cr>' end,
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
