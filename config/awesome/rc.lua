-- Standard awesome library
awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
wibox = require("wibox")
-- Theme handling library
beautiful = require("beautiful")
-- Notification library
naughty = require("naughty")
package.path = package.path .. ';/home/smockey/git/powerline/powerline/bindings/awesome/?.lua'
require('powerline')

-- {{{ Variable definitions

-- This is used later as the default terminal and editor to run.
terminal = "sakura"
terminal_exec = terminal .. " -x "
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal_exec .. editor
newline = "\n" -- This is used in a zsh scripts related to naughty
-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod1"

-- }}}

require "layout"
require "bindings"
require "signals"
require "rules"
