require('beautiful').init(require('themes.xresources'))
require('awful.autofocus')

require('panel')
require('signals')
require('rules')

local keymaps = require('keymaps')

root.keys(keymaps.keyboard.root)
root.buttons(keymaps.mouse.root)

require('startup').boot()
