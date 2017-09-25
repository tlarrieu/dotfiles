local _M = {}

_M.load = function()
  local output = io.popen('xrdb -query')
  local query = output:read('*a')
  output:close()

  local scheme = {}
  for i, color in string.gmatch(query, "*.color(%d+):[^#]*(#[%a%d]+)") do
    scheme['color' .. i] = color
  end

  scheme.background = string.match(query, "*.background:[^#]*(#[%a%d]+)")
  scheme.foreground = string.match(query, "*.foreground:[^#]*(#[%a%d]+)")

  return {
    foreground = scheme.foreground,
    background = scheme.background,
    black   = { dark = scheme.color0, light = scheme.color8 },
    red     = { dark = scheme.color1, light = scheme.color9 },
    green   = { dark = scheme.color2, light = scheme.color10 },
    yellow  = { dark = scheme.color3, light = scheme.color11 },
    blue    = { dark = scheme.color4, light = scheme.color12 },
    magenta = { dark = scheme.color5, light = scheme.color13 },
    cyan    = { dark = scheme.color6, light = scheme.color14 },
    white   = { dark = scheme.color7, light = scheme.color15 },
  }
end

return _M
