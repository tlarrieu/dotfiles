--[[ Awesome modules ]]---------------------------------------------------------

-- Standard awesome library
awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
wibox = require("wibox")
-- Theme handling library
beautiful = require("beautiful")
-- Notification library
naughty = require("naughty")
-- Wallpaper handling library
gears = require("gears")

--[[ Configuration ]]-----------------------------------------------------------

require "layout"
require "bindings"
require "signals"
require "rules"

--[[ Startup ]]-----------------------------------------------------------------

-- Xcape
awful.util.spawn_with_shell("killall xcape; xcape -e 'Control_L=Escape'")

-- Xflux
awful.util.spawn_with_shell(
  "xflux -l 48.8562213 -g 2.3486073"
) -- Paris coordinates
