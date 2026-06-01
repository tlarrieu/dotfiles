local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi
local naughty = require('naughty')

return {
  config = function()
    local output = io.popen([[
      gsettings get org.gnome.desktop.interface color-scheme |
        grep -Eo "light|dark"
    ]])
    local mode = ''
    if output then
      mode = output:read('*a'):gsub('%s+', '')
      if mode ~= 'light' and mode ~= 'dark' then mode = 'light' end
      output:close()
    end

    local _, colors = pcall(require, "colors." .. mode)

    local theme = {}

    theme.colors = colors
    theme.useless_gap = dpi(3)

    local accent = colors.green.dark

    theme.font = "CaskaydiaCove Nerd Font 12"
    theme.taglist_bg_focus = colors.background .. '00'

    theme.fg_normal = colors.foreground
    theme.fg_focus = accent
    theme.fg_urgent = colors.white.light

    theme.tasklist_fg_focus = colors.black.light

    theme.bg_normal = colors.background
    theme.bg_focus = colors.background
    theme.bg_urgent = colors.red.dark
    theme.bg_systray = colors.bg_normal

    theme.border_width = 0
    theme.border_normal = colors.white.dark
    theme.border_focus = colors.green.dark

    theme.notification_bg = colors.foreground
    theme.notification_fg = colors.background
    theme.notification_margin = dpi(12)
    theme.notification_border_color = colors.foreground
    theme.notification_border_width = 0
    theme.notification_icon_size = dpi(32)

    theme.progressbar_bg = colors.foreground
    theme.progressbar_fg = colors.background
    theme.progressbar_paddings = dpi(1)

    theme.notification_font = theme.font_name

    beautiful.init(theme)

    naughty.config.padding = dpi(18)
    naughty.config.spacing = dpi(10)
    naughty.config.presets.critical.bg = colors.red.dark
    naughty.config.presets.critical.fg = colors.white.light
  end
}
