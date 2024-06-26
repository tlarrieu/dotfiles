local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi
local naughty = require('naughty')

return {
  config = function()
    local xrdb = require('xrdb').load()
    local theme = {}

    theme.colors = xrdb.colors
    theme.useless_gap = dpi(6)

    local accent = theme.colors.magenta.dark

    theme.font = xrdb.font.name .. " " .. xrdb.font.size

    theme.fg_normal = theme.colors.foreground
    theme.fg_focus = accent
    theme.fg_urgent = theme.colors.white.light

    theme.tasklist_fg_focus = theme.colors.black.light

    theme.bg_normal = theme.colors.background
    theme.bg_focus = theme.colors.background
    theme.bg_urgent = theme.colors.red.dark
    theme.bg_systray = theme.bg_normal

    theme.border_width = 0
    -- theme.border_normal = theme.colors.background
    -- theme.border_focus = accent
    -- theme.border_urgent = theme.colors.red.dark

    theme.notification_bg = theme.colors.background
    theme.notification_fg = theme.colors.foreground
    theme.notification_border_color = theme.colors.background
    theme.notification_icon_size = dpi(32)

    theme.notification_font = xrdb.font.name .. " " .. tonumber(xrdb.font.size)*1.1

    beautiful.init(theme)

    naughty.config.padding = dpi(10)
    naughty.config.spacing = dpi(6)
    naughty.config.presets.critical.bg = theme.colors.red.dark
    naughty.config.presets.critical.fg = theme.colors.white.light
  end
}
