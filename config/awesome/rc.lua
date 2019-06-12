require("beautiful").init(
  os.getenv("HOME") .. "/.config/awesome/themes/xresources/theme.lua"
)
require("awful.autofocus")
require("naughty")

require("screendpi")
require("panel")
require("signals")
require("rules")

root.keys(require("bindings").keyboard.root)

require("awful").spawn(os.getenv("HOME") .. "/startup.sh")
