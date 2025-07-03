local _M = {}

_M.number = function(i)
  local lookup = { '󰎤', '󰎧', '󰎪', '󰎭', '󰎱', '󰎳', '󰎶', '󰎹', '󰎼', '󰎡' }
  return lookup[i] and lookup[i] or ''
end

return _M
