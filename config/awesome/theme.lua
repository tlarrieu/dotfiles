local beautiful = require('beautiful')
local naughty = require('naughty')

return {
  config = function()
    local colors = loadfile(os.getenv('HOME') .. '/.config/awesome/colors/' .. require('mode').current() .. '.lua')()

    local theme = {}

    theme.colors = colors
    theme.useless_gap = 3

    local font_name = 'CaskaydiaCove Nerd Font'
    theme.font = ('%s 10.5'):format(font_name)
    theme.taglist_font = ('%s 12'):format(font_name)

    theme.fg_normal = colors.fg.base
    theme.fg_focus = colors.fg.base
    theme.fg_urgent = colors.bg.dim

    -- hack to change taglist default color (since all our tags are volatile anyways)
    theme.taglist_fg_volatile = colors.fg.dim
    theme.taglist_fg_focus = colors.fg.base
    theme.taglist_bg_focus = colors.bg.dimmer

    theme.bg_normal = colors.bg.base
    theme.bg_focus = nil
    theme.bg_urgent = colors.red.base
    theme.bg_systray = colors.bg.base

    theme.border_width = 0

    theme.notification_bg = colors.fg.base
    theme.notification_fg = colors.bg.base
    theme.notification_margin = 12
    theme.notification_border_color = colors.fg.base
    theme.notification_border_width = 0
    theme.notification_icon_size = 32

    theme.progressbar_bg = colors.fg.base
    theme.progressbar_fg = colors.bg.base
    theme.progressbar_paddings = 1

    theme.notification_font = theme.font

    beautiful.init(theme)

    naughty.config.padding = 18
    naughty.config.spacing = 10
    naughty.config.presets.critical.border_width = 0
    naughty.config.presets.critical.bg = colors.red.dim
    naughty.config.presets.critical.fg = colors.red.base
  end
}
