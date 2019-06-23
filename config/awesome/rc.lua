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

local path = "/tmp/awesome_started"
local f = io.open(path, "r")

if not f then
  require("awful").spawn.with_shell(os.getenv("HOME") .. "/startup.sh")
  io.open(path, "w"):close()
else
  f:close()
end
