require('beautiful').init(os.getenv('HOME') .. '/.config/awesome/themes/xresources/theme.lua')
require('awful.autofocus')

require('panel')
require('signals')
require('rules')

local keymaps = require('keymaps')

root.keys(keymaps.keyboard.root)
root.buttons(keymaps.mouse.root)

require('startup').boot()
