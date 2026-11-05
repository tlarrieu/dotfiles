--- Tooltips of the panel widgets: require('widgets.tooltip').make(object)
--- Colors and font come from the theme (theme.lua: tooltip_*).

local awful = require('awful')

local M = {}

-- A tooltip shown below `object`, roomy, with its top aligned with the tiled
-- clients: the panel's bottom edge sits two useless gaps (3px each) above them
---@param object Widget The widget hovering shows the tooltip for
---@return Tooltip
M.make = function(object)
  return awful.tooltip({
    objects = { object },
    mode = 'outside',
    preferred_alignments = { 'middle' },
    margin_leftright = 12,
    margin_topbottom = 12,
    gaps = { top = 6, bottom = 6, left = 0, right = 0 },
  })
end

return M
