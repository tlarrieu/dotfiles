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

-- Redshift
awful.util.spawn_with_shell("run_once redshift")

-- Configure keys
awful.util.spawn_with_shell("run_once xmodmap ~/.Xmodmap")
awful.util.spawn_with_shell("run_once xcape -e 'Control_L=Escape'")
awful.util.spawn_with_shell("run_once setxkbmap -option ctrl:nocaps")
awful.util.spawn_with_shell("run_once xcompmgr")

-- Touchegg
-- awful.util.spawn_with_shell("run_once touchegg")
