local getpos = function(query)
  local res = vim.fn.getpos(query)
  return res[2], res[3]
end

local wrap = function(query)
  return { cmd = { 'psql', '-c', query }, winbar = ' psql' }
end

local select = function(selector)
  local cursor = vim.api.nvim_win_get_cursor(0)
  vim.cmd.normal(selector .. '')
  local srow, scol = getpos("'<")
  local erow, ecol = getpos("'>")
  vim.api.nvim_win_set_cursor(0, cursor)

  local query = table.concat(vim.api.nvim_buf_get_text(0, srow - 1, scol - 1, erow - 1, ecol, {}), '\n')

  return query
end

require('runner').setup({
  main = { args = function() return wrap(select('vip')) end, desc = 'psql -f %' },
  alt = { args = function() return wrap('\\d ' .. select('viw')) end, desc = 'psql -f %' },
  repl = { args = { cmd = 'psql', winbar = ' psql' } },
})
