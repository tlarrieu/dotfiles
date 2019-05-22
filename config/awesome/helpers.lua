local awful = require("awful")

local _M = {}

_M.create_tag = function(screen)
  local config = {
    layout = awful.layout.suit.fair,
    master_width_factor = 0.75,
    screen = screen or awful.screen.focused(),
    volatile = true
  }

  return awful.tag.add("", config)
end

_M.create_tag_and_attach_to = function(client)
  local screen = client.screen

  local tag = _M.create_tag(screen)
  client:tags({ tag })
  tag:view_only()
end

return _M