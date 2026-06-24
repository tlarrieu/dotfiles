local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi
local naughty = require('naughty')

return {
  config = function()
    local colors = loadfile(os.getenv('HOME') .. '/.config/awesome/colors/' .. require('mode').current() .. '.lua')()

    local theme = {}

    theme.colors = colors
    theme.useless_gap = dpi(3)

    theme.font = "CaskaydiaCove Nerd Font 12"
    theme.taglist_bg_focus = colors.accent.base .. '00'

    theme.fg_normal = colors.fg.dim
    theme.fg_focus = colors.fg.base
    theme.fg_urgent = colors.white.dim

    theme.tasklist_fg_focus = colors.black.dim

    theme.bg_normal = colors.bg.base
    theme.bg_focus = colors.bg.base
    theme.bg_urgent = colors.red.base
    theme.bg_systray = colors.bg_normal

    theme.border_width = 0
    theme.border_normal = colors.white.base
    theme.border_focus = colors.green.base

    theme.notification_bg = colors.fg.base
    theme.notification_fg = colors.bg.base
    theme.notification_margin = dpi(12)
    theme.notification_border_color = colors.fg.base
    theme.notification_border_width = 0
    theme.notification_icon_size = dpi(32)

    theme.progressbar_bg = colors.fg.base
    theme.progressbar_fg = colors.bg.base
    theme.progressbar_paddings = dpi(1)

    theme.notification_font = theme.font

    beautiful.init(theme)

    naughty.config.padding = dpi(18)
    naughty.config.spacing = dpi(10)
    naughty.config.presets.critical.bg = colors.red.base
    naughty.config.presets.critical.fg = colors.white.dim
  end
}
