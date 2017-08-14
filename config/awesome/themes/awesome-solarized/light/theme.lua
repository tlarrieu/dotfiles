local theme = {}

-- [[ palette ]] ---------------------------------------------------------------
local scheme = require('beautiful.xresources').get_current_theme()

theme.colors = {
  foreground = scheme.foreground,
  background = scheme.background,
  black   = { dark = scheme.color0, light = scheme.color8 },
  red     = { dark = scheme.color1, light = scheme.color9 },
  green   = { dark = scheme.color2, light = scheme.color10 },
  yellow  = { dark = scheme.color3, light = scheme.color11 },
  blue    = { dark = scheme.color4, light = scheme.color12 },
  magenta = { dark = scheme.color5, light = scheme.color13 },
  cyan    = { dark = scheme.color6, light = scheme.color14 },
  white   = { dark = scheme.color7, light = scheme.color15 },
}

-- [[ styles ]] ----------------------------------------------------------------
theme.font      = "InconsolataForPowerline Nerd Font 13"

-- [[ colors ]] ----------------------------------------------------------------
theme.fg_normal         = theme.colors.foreground
theme.fg_focus          = theme.colors.magenta.dark
theme.fg_urgent         = theme.colors.white.light

theme.tasklist_fg_focus = theme.colors.black.light

theme.bg_normal         = theme.colors.background
theme.bg_focus          = theme.colors.background
theme.bg_urgent         = theme.colors.red.dark
theme.bg_systray        = theme.bg_normal

-- [[ titlebars ]] -------------------------------------------------------------
theme.titlebar_bg_focus  = theme.bg_focus
theme.titlebar_bg_normal = theme.bg_normal

-- [[ icons ]] -----------------------------------------------------------------
local theme_path = os.getenv("HOME") .. "/.config/awesome/themes/awesome-solarized/light/"
-- taglist
theme.taglist_squares_sel   = theme_path.."taglist/square_sel.png"
theme.taglist_squares_unsel = theme_path.."taglist/square_unsel.png"

return theme
