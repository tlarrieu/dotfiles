local awful = require("awful")

local _M = {}

_M.create_tag = function(screen)
  local config = {
    layout = awful.layout.suit.fair,
    master_width_factor = 0.72,
    screen = screen or awful.screen.focused(),
    volatile = true
  }

  return awful.tag.add("", config)
end

_M.create_tag_and_attach_to = function(force)
  return function(client)
    local screen = client.screen
    local tag

    if not force and client.floating and not client.fullscreen then
      tag = screen.selected_tag
    end

    tag = tag or _M.create_tag(screen)

    client:tags({ tag })
    tag:view_only()
  end
end

_M.resize_and_center = function(client)
  local factor = 0.8

  local swidth = client.screen.geometry.width
  local sheight = client.screen.geometry.height

  local width = math.min(1920, swidth * factor)
  local height = math.min(1080, sheight * factor)
  local x = (swidth - width) / 2
  local y = (sheight - height) / 2

  client:geometry({ x = x, y = y, width = width, height = height })
end

_M.center_mouse_in_client = function(client)
  local geo = client:geometry()

  mouse.coords {
    x = geo.x + geo.width / 2,
    y = geo.y + geo.height / 2
  }
end

return _M
