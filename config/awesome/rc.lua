require('awful.autofocus')
require('naughty.dbus')

require('theme').config()
require('keymaps').config()

require('panel')
require('signals')
require('rules')

require('startup').boot()
