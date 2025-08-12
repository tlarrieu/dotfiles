local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi
local naughty = require('naughty')

return {
  config = function()
    local xrdb = require('xrdb').load()
    local theme = {}

    theme.colors = xrdb.colors
    theme.useless_gap = dpi(3)

    local accent = theme.colors.blue.dark

    theme.font = xrdb.font.name .. " " .. xrdb.font.size
    theme.taglist_bg_focus = theme.colors.background .. '00'

    theme.fg_normal = theme.colors.foreground
    theme.fg_focus = accent
    theme.fg_urgent = theme.colors.white.light

    theme.tasklist_fg_focus = theme.colors.black.light

    theme.bg_normal = theme.colors.background
    theme.bg_focus = theme.colors.background
    theme.bg_urgent = theme.colors.red.dark
    theme.bg_systray = theme.bg_normal

    theme.border_width = 2.5
    theme.border_normal = theme.colors.white.dark
    theme.border_focus = theme.colors.green.dark

    theme.notification_bg = theme.colors.foreground
    theme.notification_fg = theme.colors.background
    theme.notification_margin = dpi(12)
    theme.notification_border_color = theme.colors.foreground
    theme.notification_border_width = 0
    theme.notification_icon_size = dpi(32)

    theme.progressbar_bg = theme.colors.foreground
    theme.progressbar_fg = theme.colors.background
    theme.progressbar_paddings = dpi(1)

    theme.notification_font = xrdb.font.name .. " " .. tonumber(xrdb.font.size)

    beautiful.init(theme)

    naughty.config.padding = dpi(18)
    naughty.config.spacing = dpi(10)
    naughty.config.presets.critical.bg = theme.colors.red.dark
    naughty.config.presets.critical.fg = theme.colors.white.light
  end
}
