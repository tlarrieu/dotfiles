local _M = {}

_M.basename = function()
  local filename = vim.api.nvim_buf_get_name(0):match("^.+/(.+)$")
  local basename = (filename or ''):match("(.+)[.].+")
  return basename or filename or ""
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

return _M
