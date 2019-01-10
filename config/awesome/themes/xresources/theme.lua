package.path = package.path .. ';/home/tlarrieu/scripts/?.lua'

local dpi = require('beautiful.xresources').apply_dpi
local xrdb = require('xrdb').load()

local theme = {}

-- [[ palette ]] ---------------------------------------------------------------

theme.colors = xrdb.colors
theme.useless_gap = dpi(10)

-- [[ styles ]] ----------------------------------------------------------------
theme.font = xrdb.font.name .. " " .. 12

-- [[ colors ]] ----------------------------------------------------------------
theme.fg_normal = theme.colors.foreground
theme.fg_focus = theme.colors.magenta.dark
theme.fg_urgent = theme.colors.white.light

theme.tasklist_fg_focus = theme.colors.black.light

theme.bg_normal = theme.colors.background
theme.bg_focus = theme.colors.background
theme.bg_urgent = theme.colors.red.dark
theme.bg_systray = theme.bg_normal

theme.border_width = dpi(2)
theme.border_normal = theme.colors.background
theme.border_focus = theme.colors.magenta.dark
theme.border_urgent = theme.colors.red.dark

-- [[ titlebars ]] -------------------------------------------------------------
theme.titlebar_bg_focus  = theme.bg_focus
theme.titlebar_bg_normal = theme.bg_normal

-- [[ icons ]] -----------------------------------------------------------------
local theme_path = os.getenv("HOME") .. "/.config/awesome/themes/xresources/"
-- taglist
theme.taglist_squares_sel   = theme_path.."taglist/square_sel.png"
theme.taglist_squares_unsel = theme_path.."taglist/square_unsel.png"

return theme
