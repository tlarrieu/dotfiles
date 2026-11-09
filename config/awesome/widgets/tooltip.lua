--- Tooltips of the panel widgets: require('widgets.tooltip').make(object)
--- Colors and font come from the theme (theme.lua: tooltip_*).

local awful = require('awful')
local beautiful = require('beautiful')

local M = {}

-- A tooltip shown below `object`, roomy, with its top aligned with the tiled
-- clients: the panel's bottom edge sits two useless gaps above them
---@param object Widget The widget hovering shows the tooltip for
---@return Tooltip
M.make = function(object)
  ---@type Tooltip
  local tooltip = awful.tooltip({
    objects = { object },
    mode = 'outside',
    preferred_positions = { 'bottom' },
    -- Centered under the widget, else flush with its right edge (or its left
    -- one): awesome places it nowhere when none of these fits, leaving it
    -- wherever it last was
    preferred_alignments = { 'middle', 'back', 'front' },
    margin_leftright = 12,
    margin_topbottom = 12,
    gaps = { top = 2 * beautiful.useless_gap, bottom = 2 * beautiful.useless_gap, left = 0, right = 0 },
  })

  -- Keep off the screen's right edge, in line with the tiled clients (two
  -- useless gaps in): awesome only keeps tooltips on screen, flush with the
  -- edge. Placed on every show and content change; moving it signals
  -- again, then it's already in place
  local window = tooltip:get_wibox()
  window:connect_signal('property::geometry', function()
    local screen_geometry = window.screen.geometry
    local right = screen_geometry.x + screen_geometry.width - 2 * beautiful.useless_gap
    if window.x + window.width > right then window.x = right - window.width end
  end)

  return tooltip
end

return M
