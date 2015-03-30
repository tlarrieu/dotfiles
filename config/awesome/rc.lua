-- {{{ Awesome modules ---------------------------------------------------------
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
-- }}}

-- {{{ Variable definitions ----------------------------------------------------
-- This is used later as the default terminal and editor to run.
terminal = "termite"
terminal_exec = terminal .. " -e "
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal_exec .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with
-- others.
modkey = "Mod4"
-- }}}

-- {{{ Configuration -----------------------------------------------------------
require "layout"
require "bindings"
require "signals"
require "rules"
-- }}}

-- {{{ Startup -----------------------------------------------------------------
-- Xcape
awful.util.spawn_with_shell("killall xcape")
awful.util.spawn_with_shell("xcape -e 'Control_L=Escape'")

-- Xflux
awful.util.spawn_with_shell("killall xflux")
awful.util.spawn_with_shell(
  "xflux -l 48.8562213 -g 2.3486073"
) -- Paris coordinates

-- ssh keychain
awful.util.spawn_with_shell(
  "keychain --eval --agents ssh -Q --quiet ~/.ssh/id_rsa"
)
-- }}}
