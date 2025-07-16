local _M = {}

_M.basename = function()
  local filename = vim.api.nvim_buf_get_name(0):match("^.+/(.+)$")
  local basename = (filename or ''):match("(.+)[.].+")
  return basename or filename or ""
end

_M.dirname = function()
  local filename = vim.api.nvim_buf_get_name(0)
  local dirname = filename:match("^(.+)/.+$")

  if vim.fn.isdirectory(filename) == 1 then
    return filename:match("^.+/(.+)$")
  end

  return dirname:match("^.+/(.+)$")
end

_M.fileexists = function(path)
  local f = io.open(path, "rb")
  if f then f:close() end
  return f ~= nil
end

_M.capitalize = function(str)
  return str:gsub("^%a", string.upper, 1) or str
end

_M.camelize = function(str)
  if not (str:find("_")) then
    return str:lower()
  end
  return str:gsub('(_)([a-z])', function(_, l) return l:upper() end) or str
end

_M.pascalize = function(str)
  return _M.capitalize(_M.camelize(str))
end

_M.snakify = function(str)
  return str:gsub('([a-z])([A-Z])', '%1_%2'):lower() or str
end

_M.coerce = function(str, width)
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

_M.merge = function(left, right)
  return vim.tbl_deep_extend('keep', left, right)
end

return _M
