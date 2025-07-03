local _M = {}

-- remove ANSI escape sequence from input string
_M.strip = function(str)
  return str:gsub("[\27\155][][()#;?%d]*[A-PRZcf-ntqry=><~]", '')
end

return _M
