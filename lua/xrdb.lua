local _M = {}

_M.load = function()
  local output = io.popen('xrdb -query')
  local query = ''
  if output then
    query = output:read('*a')
    output:close()
  end

  local scheme = {}
  for i, color in string.gmatch(query, "*.color(%d+):[^#]*(#[%a%d]+)") do
    scheme['color' .. i] = color
  end

  scheme.background = string.match(query, "*.background:[^#]*(#[%a%d]+)")
  scheme.foreground = string.match(query, "*.foreground:[^#]*(#[%a%d]+)")
  scheme.comment = string.match(query, "*.comment:[^#]*(#[%a%d]+)")

  local vim = {
    theme = string.match(query, "vim.theme:%s*(%a+)"),
    background = string.match(query, "vim.background:%s*(%a+)"),
  }

  local name, size, dpi = string.match(
    query,
    "*.font:%s*xft:([ %a]+):size=(%d+):dpi=(%d+)"
  )
  local font = { name = name, size = size, dpi = dpi }

  return {
    colors = {
      foreground = scheme.foreground,
      background = scheme.background,
      comment    = scheme.comment,
      black      = { dark = scheme.color0, light = scheme.color8 },
      red        = { dark = scheme.color1, light = scheme.color9 },
      green      = { dark = scheme.color2, light = scheme.color10 },
      yellow     = { dark = scheme.color3, light = scheme.color11 },
      blue       = { dark = scheme.color4, light = scheme.color12 },
      magenta    = { dark = scheme.color5, light = scheme.color13 },
      cyan       = { dark = scheme.color6, light = scheme.color14 },
      white      = { dark = scheme.color7, light = scheme.color15 },
    },
    vim = vim,
    font = font
  }
end

local function round(x)
  return x >= 0 and math.floor(x + 0.5) or math.ceil(x - 0.5)
end

_M.apply_dpi = function(size, dpi)
  return round(size / 96 * dpi)
end

return _M
