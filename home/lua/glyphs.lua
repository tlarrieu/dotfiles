local M = {}

M.number = function(i)
  local lookup = { '󰎤', '󰎧', '󰎪', '󰎭', '󰎱', '󰎳', '󰎶', '󰎹', '󰎼', '󰎡' }
  return lookup[i] and lookup[i] or ''
end

return M
