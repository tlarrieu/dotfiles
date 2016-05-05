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

--[[ Plugins ]]-----------------------------------------------------------------

battery = require("plugins/batmon")

--[[ Configuration ]]-----------------------------------------------------------

require "layout"
require "bindings"
require "signals"
require "rules"

--[[ Startup ]]-----------------------------------------------------------------

-- Xflux
awful.util.spawn_with_shell("killall xflux; xflux -l 48.8562213 -g 2.3486073") -- Paris coordinates
-- awful.util.spawn_with_shell("killall xflux; xflux -l 35.6732615 -g 139.5699578") -- Tokyo coordinates

-- Configure keys
awful.util.spawn_with_shell("killall xcape; xcape -e 'Control_L=Escape'")
awful.util.spawn_with_shell("setxkbmap -option ctrl:nocaps; xmodmap ~/.Xmodmap")

-- Touchegg
awful.util.spawn_with_shell("killall touchegg; touchegg")
