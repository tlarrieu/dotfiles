local getpos = function(query)
  local res = vim.fn.getpos(query)
  return res[2], res[3]
end

local select = function(selector)
  return function()
    local cursor = vim.api.nvim_win_get_cursor(0)
    vim.cmd.normal(selector .. '')
    local srow, scol = getpos("'<")
    local erow, ecol = getpos("'>")
    vim.api.nvim_win_set_cursor(0, cursor)

    local query = table.concat(vim.api.nvim_buf_get_text(0, srow - 1, scol - 1, erow - 1, ecol, {}), '\n')

    return { cmd = { 'psql', '-c', query }, winbar = ' psql' }
  end
end

require('runner').setup({
  main = { args = select('vip'), desc = 'psql -f %' },
  alt = { args = select('vis'), desc = 'psql -f %' },
  repl = { args = { cmd = 'psql', winbar = ' psql' } },
})
