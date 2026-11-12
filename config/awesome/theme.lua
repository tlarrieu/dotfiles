local beautiful = require('beautiful')
local naughty = require('naughty')

return {
  config = function()
    local colors = loadfile(os.getenv('HOME') .. '/.config/awesome/colors/' .. require('mode').current() .. '.lua')()

    local theme = {}

    theme.colors = colors
    theme.useless_gap = 3

    local font_name = 'CaskaydiaCove Nerd Font'
    theme.font = ('%s 11'):format(font_name)
    theme.taglist_font = ('%s 12'):format(font_name)
    -- Glyphs: the Mono variant keeps them within a single cell
    theme.icon_font = ('%s Mono'):format(font_name)

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

    theme.tooltip_bg = theme.notification_bg
    theme.tooltip_fg = theme.notification_fg
    theme.tooltip_border_width = 0
    theme.tooltip_font = ('%s 12'):format(font_name)

    beautiful.init(theme)

    naughty.config.padding = 18
    naughty.config.spacing = 10
    naughty.config.presets.critical.border_width = 0
    naughty.config.presets.critical.bg = colors.red.dim
    naughty.config.presets.critical.fg = colors.red.base

    -- Job notifications from nvim (git, see config/nvim/lua/plug/git.lua; rspec, see config/nvim/ftplugin/ruby.lua):
    -- blue when started, green when done, red when failed (still expiring, unlike errors).
    -- Awesome matches on the app name, not on the category hint.
    local job_presets = {
      ['nvim.job.started'] = colors.blue,
      ['nvim.job.done'] = colors.green,
      ['nvim.job.failed'] = colors.red,
    }
    for appname, color in pairs(job_presets) do
      table.insert(require('naughty.dbus').config.mapping, { { appname = appname }, { border_width = 0, bg = color.dim, fg = color.base } })
    end
  end
}
