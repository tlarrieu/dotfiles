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

_M.create_tag_if_needed = function()
  local current_tag = awful.screen.focused().selected_tag
  local alltags = awful.screen.focused().tags
  local lasttag = alltags[#alltags]

  if current_tag == lasttag and #current_tag:clients() > 1 then
    _M.create_tag()
  end
end

_M.create_tag_and_attach_to = function(client)
  local screen = client.screen
  if #screen.tags == 0 then
    local tag = _M.create_tag(screen)
    awful.tag.viewtoggle(tag)
    client:tags({tag})
  end
end

return _M
