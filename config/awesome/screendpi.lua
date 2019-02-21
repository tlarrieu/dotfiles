-- find a way to change borderwidth per screen
local compute_dpi = function(screen)
  local mm_per_inch = 25.4

  -- Try to compute DPI based on outputs (use the minimum)
  local dpi
  local geo = screen.geometry
  for _, o in pairs(screen.outputs) do
    -- Ignore outputs with width/height 0
    if o.mm_width ~= 0 and o.mm_height ~= 0 then
      local dpix = geo.width * mm_per_inch / o.mm_width
      local dpiy = geo.height * mm_per_inch / o.mm_height
      dpi = math.min(dpix, dpiy, dpi or dpix)
    end
  end

  -- Hard fallback to "standard" X dpi
  dpi = dpi or 96

  -- hack to handle 4k monitors
  -- TODO: get rid of that shit
  if dpi > 300 then return dpi / 2 end
  return dpi
end

require("awful").screen.connect_for_each_screen(function(screen)
  screen:set_dpi(compute_dpi(screen))
end)
