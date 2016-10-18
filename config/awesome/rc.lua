-- [[ Awesome modules ]] -------------------------------------------------------

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

-- [[ Plugins ]] ---------------------------------------------------------------

require("plugins/batmon")
require("plugins/run_or_raise")

-- [[ Configuration ]] ---------------------------------------------------------

require "layout"
require "bindings"
require "signals"
require "rules"
