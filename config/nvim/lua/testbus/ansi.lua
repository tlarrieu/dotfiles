local _M = {}

---@return string # input string stripped of ANSI escape sequence
_M.strip = function(str)
  return str:gsub("[\27\155][][()#;?%d]*[A-PRZcf-ntqry=><~]", '')
end

return _M
