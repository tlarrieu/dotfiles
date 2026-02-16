local M = {}

M.basename = function()
  local filename = vim.api.nvim_buf_get_name(0):match("^.+/(.+)$")
  local basename = (filename or ''):match("(.+)[.].+")
  return basename or filename or ""
end

M.dirname = function()
  local filename = vim.api.nvim_buf_get_name(0)
  local dirname = filename:match("^(.+)/.+$")

  if vim.fn.isdirectory(filename) == 1 then
    return filename:match("^.+/(.+)$")
  end

  return dirname:match("^.+/(.+)$")
end

M.fileexists = function(path)
  local f = io.open(path, "rb")
  if f then f:close() end
  return f ~= nil
end

M.capitalize = function(str)
  return str:gsub("^%a", string.upper, 1) or str
end

M.camelize = function(str)
  if not (str:find("_")) then
    return str:lower()
  end
  return str:gsub('(_)([a-z])', function(_, l) return l:upper() end) or str
end

M.pascalize = function(str)
  return M.capitalize(M.camelize(str))
end

M.snakify = function(str)
  return str:gsub('([a-z])([A-Z])', '%1_%2'):lower() or str
end

M.coerce = function(str, width)
  local count, res = 0, ''
  for word in str:gmatch('%S+') do
    count = count + #word
    if count >= width then
      res = res .. "\n"
      count = 0
    end
    res = res .. word .. ' '
  end
  return res
end

M.merge = function(left, right)
  return vim.tbl_deep_extend('keep', left, right)
end

M.strip = function(string)
  local lines = {}
  for line in string:gmatch('[^\n]+') do
    local stripped, _ = line:gsub('^ *', '')
    table.insert(lines, stripped)
  end
  return table.concat(lines, '\n')
end

return M
