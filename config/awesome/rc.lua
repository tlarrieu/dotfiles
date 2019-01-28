local themedir = os.getenv("HOME") .. "/.config/awesome/themes"
require("awful.autofocus")
require("beautiful").init(themedir .. "/xresources/theme.lua")
require("bindings")
require("panel")
require("signals")
require("rules")
require("naughty")
