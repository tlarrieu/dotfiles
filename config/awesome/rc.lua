require('beautiful').init(require('themes.xresources').init())
require('awful.autofocus')

require('naughty.dbus')

require('panel')
require('signals')
require('rules')

local keymaps = require('keymaps')

root.keys(keymaps.keyboard.root)
root.buttons(keymaps.mouse.root)

require('startup').boot()
