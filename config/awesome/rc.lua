require("beautiful").init(
  os.getenv("HOME") .. "/.config/awesome/themes/xresources/theme.lua"
)
require("awful.autofocus")
require("naughty")

require("panel")
require("signals")
require("rules")

local awful = require("awful")

local bindings = require("bindings")

root.keys(bindings.keyboard.root)
root.buttons(bindings.mouse.root)

require('startup').boot()

-- Disable screen saving / blanking
awful.spawn.with_shell("xset s off -dpms")
