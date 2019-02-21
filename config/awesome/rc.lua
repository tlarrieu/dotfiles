local themedir = os.getenv("HOME") .. "/.config/awesome/themes"
local theme = 'xresources/theme.lua'

require("beautiful").init(themedir .. "/" .. theme)
require("screendpi")
require("awful.autofocus")
require("bindings")
require("panel")
require("signals")
require("rules")
require("naughty")
